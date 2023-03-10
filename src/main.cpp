#include <stdint.h>                    // *int*_t

#include <bgfx/bgfx.h>                 // bgfx::*
#include <bgfx/embedded_shader.h>      // BGFX_EMBEDDED_SHADER

#include <bx/bx.h>                     // BX_CONCATENATE
#include <bx/math.h>                   // mtxOrtho, mtxRotateZ, round
#include <bx/platform.h>               // BX_PLATFORM_*
#include <bx/string.h>                 // snprintf

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

#include <glm/glm.hpp>                    // glm::*
#include <glm/gtc/matrix_transform.hpp>   // lookAt
#include <glm/gtc/type_ptr.hpp>           // value_ptr

#define ARCBALL_CAMERA_IMPLEMENTATION
#include <arcball_camera.h>               // arcball_camera_update

#include "imgui.h"                        // imgui_*, ImGui::*, ImGuizmo::*

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

static bgfx::Init create_bgfx_init(GLFWwindow* window)
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
// EDITOR CAMERA
// -----------------------------------------------------------------------------

struct ArcballUpdateData
{
    ImVec4 viewport        = {};
    ImVec2 position_old    = {};
    ImVec2 position_new    = {};
    float  time_delta      = 0.0f;
    float  zoom_delta      = 0.0f;
    bool   panning_active  = false;
    bool   rotation_active = false;
};

struct ArcballControls
{
    glm::mat4 view_matrix    = glm::mat4(1.0f);

    glm::vec3 eye            = { 1.0f, 0.0f, 0.0f };
    glm::vec3 target         = { 0.0f, 0.0f, 0.0f };
    glm::vec3 up             = { 0.0f, 0.0f, 0.0f };

    float     zoom_per_tick  = 0.1f;
    float     pan_speed      = 0.5f;
    float     rotation_mult  = 3.0f;

    bool      allow_rotation = true;
    bool      allow_panning  = true;
    bool      allow_zooming  = true;

    void update(const ArcballUpdateData& data)
    {
        if (up == glm::vec3(0.0f))
        {
            const glm::vec3 look     = glm::normalize(target - eye);
            const glm::vec3 world_up = { 0.0f, 1.0f, 0.0f };

            up = glm::normalize(glm::cross(glm::cross(look, world_up), look));
        }

        arcball_camera_update
        (
            glm::value_ptr(eye),
            glm::value_ptr(target),
            glm::value_ptr(up),
            nullptr,
            data.time_delta,
            zoom_per_tick,
            pan_speed,
            rotation_mult,
            data.viewport.z,
            data.viewport.w,
            data.position_old.x - data.viewport.x, data.position_new.x - data.viewport.x,
            data.position_old.y - data.viewport.y, data.position_new.y - data.viewport.y,
            data.panning_active && allow_panning,
            data.rotation_active && allow_rotation,
            data.zoom_delta * allow_zooming,
            0 // Flags.
        );

        view_matrix = glm::lookAt(eye, target, up);
    }
};


// -----------------------------------------------------------------------------
// EDITOR GUI
// -----------------------------------------------------------------------------

// Returns remaining available viewport area.
static ImVec4 update_editor_gui()
{
    ImGuiViewport* viewport = ImGui::GetMainViewport();

    ImGui::PushStyleColor(ImGuiCol_Separator, ImVec4(0,0,0,0));

    const ImGuiID dockspace_id   = ImGui::GetID("EditorDockSpace");
    const bool    dockspace_init = ImGui::DockBuilderGetNode(dockspace_id);

    // Like `ImGui::DockSpaceOverViewport`, but we need to know the ID upfront.
    {
        ImGui::SetNextWindowPos     (viewport->WorkPos );
        ImGui::SetNextWindowSize    (viewport->WorkSize);
        ImGui::SetNextWindowViewport(viewport->ID);

        constexpr ImGuiWindowFlags window_flags =
            ImGuiWindowFlags_NoBackground          |
            ImGuiWindowFlags_NoBringToFrontOnFocus | 
            ImGuiWindowFlags_NoCollapse            |
            ImGuiWindowFlags_NoDocking             |
            ImGuiWindowFlags_NoMove                |
            ImGuiWindowFlags_NoNavFocus            |
            ImGuiWindowFlags_NoResize              |
            ImGuiWindowFlags_NoTitleBar            ;

        constexpr ImGuiDockNodeFlags dockspace_flags =
            ImGuiDockNodeFlags_NoWindowMenuButton  |
            ImGuiDockNodeFlags_PassthruCentralNode ;

        char label[32];
        bx::snprintf(label, sizeof(label), "Viewport_%016x", viewport->ID);

        ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding  , 0.0f);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding   , { 0.0f, 0.0f });

        ImGui::Begin(label, nullptr, window_flags);

        ImGui::PopStyleVar(3);

        ImGui::DockSpace(dockspace_id, {}, dockspace_flags);

        ImGui::End();
    }

    ImGui::PopStyleColor();

    const char* window_name = "Modeler";

    if (!dockspace_init)
    {
        ImGui::DockBuilderRemoveNode (dockspace_id);
        ImGui::DockBuilderAddNode    (dockspace_id, ImGuiDockNodeFlags_DockSpace);
        ImGui::DockBuilderSetNodeSize(dockspace_id, viewport->Size);

        const ImGuiID dock_editor_id = ImGui::DockBuilderSplitNode(
            dockspace_id, ImGuiDir_Right, 0.35f, nullptr, nullptr
        );

        ImGui::DockBuilderDockWindow(window_name, dock_editor_id);

        ImGui::DockBuilderFinish(dockspace_id);
    }

    ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, { 0.0f, 0.0f });
    const bool editor_open = ImGui::Begin(window_name);
    ImGui::PopStyleVar();

    if (editor_open)
    {
        ImGui::PushMonospacedFont();

        // TODO: Render soruce code editor.
        ImGui::TextUnformatted("TODO...");
        
        ImGui::PopFont();
    }
    ImGui::End();

    if (!dockspace_init)
    {
        ImGui::SetNavWindow(nullptr);
    }

    if (const ImGuiDockNode* node = ImGui::DockBuilderGetCentralNode(dockspace_id))
    {
        return { node->Pos.x, node->Pos.y, node->Size.x, node->Size.y };
    }

    return {};
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

    bgfx::setDebug(BGFX_DEBUG_NONE);

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
        .add(bgfx::Attrib::Color0,   4, bgfx::AttribType::Uint8, true)
        .end();

    struct Vertex
    {
        glm::vec3 position;
        uint32_t  color;
    };

    const Vertex vertices[] =
    {
        { {-0.6f, -0.4f, 0.0f}, 0xff0000ff },
        { { 0.6f, -0.4f, 0.0f}, 0xff00ff00 },
        { { 0.0f,  0.6f, 0.0f}, 0xffff0000 },
    };
    const bgfx::VertexBufferHandle vertex_buffer = bgfx::createVertexBuffer(
        bgfx::makeRef(vertices, sizeof(vertices)),
        vertex_layout
    );
    defer(bgfx::destroy(vertex_buffer));

    bgfx::setViewClear(0 , BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH, 0x303030ff, 1.0f, 0);

    // ImGui setup -------------------------------------------------------------
    imgui_init(window, bgfx::getCaps()->limits.maxViews - 1);
    defer(imgui_shutdown());

    ArcballControls camera =
    {
        .eye    = { 0.0f, 0.0f, 2.0f },
        .target = { 0.0f, 0.0f, 0.0f },
    };

    // Program loop ------------------------------------------------------------
    while (!glfwWindowShouldClose(window))
    {
        // Update inputs.
        glfwPollEvents();

        // Update ImGui.
        imgui_begin_frame();
        const ImVec4 avail_viewport = update_editor_gui();

        // Update camera.
        {
            const  ImVec2 position_new = ImGui::GetMousePos();
            static ImVec2 position_old = position_new;

            // TODO: Make more restrictive. 
            const bool panning_active  = ImGui::IsMouseDown(ImGuiMouseButton_Right);
            const bool rotation_active = ImGui::IsMouseDown(ImGuiMouseButton_Left );

            camera.update({
                .viewport        = avail_viewport,
                .position_old    = position_old,
                .position_new    = position_new,
                .time_delta      = ImGui::GetIO().DeltaTime,
                .zoom_delta      = ImGui::GetIO().MouseWheel,
                .panning_active  = panning_active,
                .rotation_active = rotation_active,
            });

            position_old = position_new;
        }

        if (ImGui::IsKeyPressed(ImGuiKey_Escape) && !ImGui::GetIO().WantCaptureKeyboard)
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
            const ImVec2 dpi = ImGui::GetIO().DisplayFramebufferScale;
            bgfx::setViewRect(
                0,
                uint16_t(bx::round(dpi.x * avail_viewport.x)),
                uint16_t(bx::round(dpi.y * avail_viewport.y)),
                uint16_t(bx::round(dpi.x * avail_viewport.z)),
                uint16_t(bx::round(dpi.y * avail_viewport.w))
            );

            const float     aspect = avail_viewport.z / avail_viewport.w;
            const glm::mat4 proj   = glm::perspective(glm::radians(60.0f), aspect, 0.1f, 100.0f);

            bgfx::setViewTransform(0, glm::value_ptr(camera.view_matrix), glm::value_ptr(proj));

            bgfx::touch(0);
        }

        // Submit the triangle data.
        {
            // float transform[16];
            // bx::mtxRotateZ(transform, float(glfwGetTime()));

            // bgfx::setTransform(transform);
            bgfx::setVertexBuffer(0, vertex_buffer); // NOTE : No index buffer.
            bgfx::setState(BGFX_STATE_DEFAULT);

            bgfx::submit(0, program);
        }

        // Render and submit ImGui.
        imgui_end_frame();

        // Submit recorded rendering operations.
        bgfx::frame();
    }

    return 0;
}

int main(int argc, char** argv)
{
    return run(argc, argv);
}
