#include <stdint.h>                    // *int*_t

#include <bgfx/bgfx.h>                 // bgfx::*
#include <bgfx/embedded_shader.h>      // BGFX_EMBEDDED_SHADER

#include <bx/bx.h>                     // BX_CONCATENATE
#include <bx/math.h>                   // mtxOrtho, mtxRotateZ
#include <bx/platform.h>               // BX_PLATFORM_*

#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>                // glfw*

#if BX_PLATFORM_LINUX
#   define GLFW_EXPOSE_NATIVE_X11
#   define GLFW_EXPOSE_NATIVE_GLX
#elif BX_PLATFORM_OSX
#   define GLFW_EXPOSE_NATIVE_COCOA
#   define GLFW_EXPOSE_NATIVE_NSGL
#elif BX_PLATFORM_WINDOWS
#   define GLFW_EXPOSE_NATIVE_WIN32
#   define GLFW_EXPOSE_NATIVE_WGL
#endif
#include <GLFW/glfw3native.h>             // glfwGetX11Display, glfwGet*Window

#ifdef WITH_IMGUI
#   include "imgui.h"                     // imgui_*, ImGui::*
#endif

#if BX_PLATFORM_OSX
#   import <Cocoa/Cocoa.h>                // NSWindow
#   import <QuartzCore/CAMetalLayer.h>    // CAMetalLayer
#endif

#ifdef WITH_SHADERC_LIBRARY
#   include <shaderclib.h>                // compile_from_memory
#else
#   include <shaders/position_color_fs.h> // position_color_fs_*
#   include <shaders/position_color_vs.h> // position_color_vs_
#endif


// -----------------------------------------------------------------------------
// DEFERRED EXECUTION HELPER
// -----------------------------------------------------------------------------

template <typename Func>
struct Deferred
{
    Func func;

    Deferred(const Deferred&) = delete;

    Deferred& operator=(const Deferred&) = delete;

    explicit Deferred(Func&& func)
        : func(static_cast<Func&&>(func))
    {
    }

    ~Deferred()
    {
        func();
    }
};

template <typename Func>
Deferred<Func> make_deferred(Func&& func)
{
    return ::Deferred<Func>(static_cast<decltype(func)>(func));
}

#define defer(...) auto BX_CONCATENATE(deferred_ , __LINE__) = \
    ::make_deferred([&]() mutable { __VA_ARGS__; })


// -----------------------------------------------------------------------------
// BGFX PLATFORM-SPECIFIC SETUP
// -----------------------------------------------------------------------------

#if BX_PLATFORM_OSX

static CAMetalLayer* create_metal_layer(NSWindow* window)
{
    CAMetalLayer* layer = [CAMetalLayer layer];

    window.contentView.layer     = layer;
    window.contentView.wantsLayer = YES;

    return layer;
}

#endif // BX_PLATFORM_OSX

[[maybe_unused]] static bgfx::Init create_bgfx_init(GLFWwindow* window)
{
    int width, height;
    glfwGetFramebufferSize(window, &width, &height);

    bgfx::Init init;
    init.resolution.width  = uint32_t(width );
    init.resolution.height = uint32_t(height);
    init.resolution.reset  = BGFX_RESET_VSYNC;

#if BX_PLATFORM_LINUX
    init.type              = bgfx::RendererType::Vulkan;
    init.platformData.ndt  = glfwGetX11Display();
    init.platformData.nwh  = reinterpret_cast<void*>(uintptr_t(glfwGetX11Window(window)));

#elif BX_PLATFORM_OSX
    init.type              = bgfx::RendererType::Metal;
    init.platformData.nwh  = create_metal_layer(static_cast<NSWindow*>(glfwGetCocoaWindow(window)));

#elif BX_PLATFORM_WINDOWS
    init.type              = bgfx::RendererType::Direct3D12;
    init.platformData.nwh  = glfwGetWin32Window(window);

#else
#   error Unsupported platform.
#endif

    return init;
}


// -----------------------------------------------------------------------------
// MAIN APPLICATION RUNTIME
// -----------------------------------------------------------------------------

static int run(int, char**)
{
    // Window creation ---------------------------------------------------------
    if (glfwInit() != GLFW_TRUE)
    {
        return 1;
    }

    defer(glfwTerminate());

    glfwDefaultWindowHints();
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindowHint(GLFW_SCALE_TO_MONITOR, GLFW_TRUE); // NOTE : Ignored when `glfwSetWindowSize` called.

    GLFWwindow* window = glfwCreateWindow(800, 600, "StarterTemplate", nullptr, nullptr);
    if (window == nullptr)
    {
        return 2;
    }

    defer(glfwDestroyWindow(window));

    int width, height;
    glfwGetFramebufferSize(window, &width, &height);

    // BGFX setup --------------------------------------------------------------
    if (!bgfx::init(create_bgfx_init(window)))
    {
        return 3;
    }

    defer(bgfx::shutdown());

    bgfx::setDebug(BGFX_DEBUG_STATS);

    // Graphics resources' creation --------------------------------------------
    bgfx::ShaderHandle vs = BGFX_INVALID_HANDLE;
    bgfx::ShaderHandle fs = BGFX_INVALID_HANDLE;

#ifdef WITH_SHADERC_LIBRARY
    const char* vs_src =
        "$input  a_position, a_color0\n"
        "$output v_color0\n"
        "#include <bgfx_shader.sh>\n"
        "void main()\n"
        "{\n"
        "    gl_Position = mul(u_modelViewProj, vec4(a_position, 1.0));\n"
        "    v_color0    = a_color0;\n"
        "}";
    const char* fs_src =
        "$input v_color0\n"
        "#include <bgfx_shader.sh>\n"
        "void main()\n"
        "{\n"
        "    gl_FragColor = v_color0;\n"
        "}";
    const char* varying_src =
        "vec4 v_color0   : COLOR0 = vec4(1.0, 0.0, 0.0, 1.0);\n"
        "vec4 a_color0   : COLOR0;\n"
        "vec3 a_position : POSITION;";

    vs = shaderc::compile_from_memory(shaderc::ShaderType::VERTEX  , vs_src, varying_src);
    fs = shaderc::compile_from_memory(shaderc::ShaderType::FRAGMENT, fs_src, varying_src);
#else
    const bgfx::EmbeddedShader shaders[] =
    {
        BGFX_EMBEDDED_SHADER(position_color_fs),
        BGFX_EMBEDDED_SHADER(position_color_vs),

        BGFX_EMBEDDED_SHADER_END()
    };

    vs = bgfx::createEmbeddedShader(shaders, bgfx::getRendererType(), "position_color_vs");
    fs = bgfx::createEmbeddedShader(shaders, bgfx::getRendererType(), "position_color_fs");
#endif

    const bgfx::ProgramHandle program = bgfx::createProgram(vs, fs, true);
    defer(bgfx::destroy(program));

    bgfx::VertexLayout vertex_layout;
    vertex_layout
        .begin()
        .add(bgfx::Attrib::Position, 3, bgfx::AttribType::Float)
        .add(bgfx::Attrib::Color0,   4, bgfx::AttribType::Float)
        .end();

    const float vertices[] =
    {
        -0.6f, -0.4f, 0.0f,  1.0f, 0.0f, 0.0f, 1.0f,
         0.6f, -0.4f, 0.0f,  0.0f, 1.0f, 0.0f, 1.0f,
         0.0f,  0.6f, 0.0f,  0.0f, 0.0f, 1.0f, 1.0f,
    };
    const bgfx::VertexBufferHandle vertex_buffer = bgfx::createVertexBuffer(
        bgfx::makeRef(vertices, sizeof(vertices)),
        vertex_layout
    );
    defer(bgfx::destroy(vertex_buffer));

    bgfx::setViewClear(0 , BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH, 0x303030ff, 1.0f, 0);

#ifdef WITH_IMGUI
    // ImGui setup -------------------------------------------------------------
    imgui_init(window, bgfx::getCaps()->limits.maxViews - 1);
    defer(imgui_shutdown());

    bool show_imgui_demo_window = true;
#endif

    // Program loop ------------------------------------------------------------
    while (!glfwWindowShouldClose(window))
    {
        // Update inputs.
        glfwPollEvents();

        bool imgui_wants_keyboard = false;

#ifdef WITH_IMGUI
        // Update ImGui.
        imgui_begin_frame();

        if (show_imgui_demo_window)
        {
            ImGui::ShowDemoWindow(&show_imgui_demo_window);
        }

        imgui_wants_keyboard = ImGui::GetIO().WantCaptureKeyboard;
#endif
 
        if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS && !imgui_wants_keyboard)
        {
            break;
        }

        // Reset the backbuffer if window size changed.
        {
            int current_width, current_height;
            glfwGetFramebufferSize(window, &current_width, &current_height);

            if (current_width != width || current_height != height)
            {
                width  = current_width;
                height = current_height;

                bgfx::reset(uint32_t(width), uint32_t(height), BGFX_RESET_VSYNC);
            }
        }

        // Set projection transform for the view.
        {
            bgfx::setViewRect(0, 0, 0, uint16_t(width), uint16_t(height));

            const float aspect = float(width) / float(height);
            float proj[16];
            bx::mtxOrtho(proj, -aspect, aspect, -1.0f, 1.0f, 1.0f, -1.0f, 0.0f, bgfx::getCaps()->homogeneousDepth);

            bgfx::setViewTransform(0, nullptr, proj);

            bgfx::touch(0);
        }

        // Submit the triangle data.
        {
            float transform[16];
            bx::mtxRotateZ(transform, float(glfwGetTime()));

            bgfx::setTransform(transform);
            bgfx::setVertexBuffer(0, vertex_buffer); // NOTE : No index buffer.
            bgfx::setState(BGFX_STATE_DEFAULT);

            bgfx::submit(0, program);
        }

#ifdef WITH_IMGUI
        // Render and submit ImGui.
        imgui_end_frame();
#endif

        // Submit recorded rendering operations.
        bgfx::frame();
    }

    return 0;
}

int main(int argc, char** argv)
{
    return run(argc, argv);
}
