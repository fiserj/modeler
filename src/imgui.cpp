#include "imgui.h"

#include <math.h>                    // roundf
#include <string.h>                  // strncpy

#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>              // glfwGetWindowContentScale

#include <imgui_impl_bgfx.h>         // ImGui_ImplBgfx_*
#include <imgui_impl_glfw_patched.h> // ImGui_ImplGlfw_*

#include "imgui_fonts.h"             // imgui_font_*


// Defined in patched version of `imgui_draw.cpp`.
float get_font_size_for_cap_size(const void* font_data, float cap_pixel_size);

static ImFont* create_imgui_font
(
    const char* font_name,
    const void* font_data,
    uint32_t    font_size,
    float       cap_pixel_size
)
{
    const float pixel_size = get_font_size_for_cap_size(font_data, cap_pixel_size);

    ImFontConfig config = {};
    config.OversampleH          = 2.0f;
    config.OversampleV          = 1.0f;
    config.FontDataOwnedByAtlas = false;
    strncpy(config.Name, font_name, sizeof(config.Name));

    return ImGui::GetIO().Fonts->AddFontFromMemoryTTF(
        const_cast<void*>(font_data),
        font_size,
        pixel_size,
        &config
    );
}

struct FontSet
{
    ImFont* base = nullptr;
    ImFont* mono = nullptr;
    float   size = 0.0f;
};

struct FontContext
{
    ImVector<FontSet> font_sets   = {};
    FontSet*          frame_fonts = nullptr;
    float             active_size = 0.0f;

    void update_frame_fonts(float dpi)
    {
        const float required_size = roundf(active_size * dpi);

        for (int i = 0; i < font_sets.size(); i++)
        {
            IM_ASSERT(font_sets[i].base != nullptr);
            IM_ASSERT(font_sets[i].mono != nullptr);

            if (font_sets[i].size == required_size)
            {
                frame_fonts = &font_sets[i];
                return;
            }
        }

        ImGui_ImplBgfx_DestroyFontsTexture();

        FontSet font_set = {};
        font_set.base = create_imgui_font("Default UI Font", imgui_font_base_data, imgui_font_base_size, required_size);
        font_set.mono = create_imgui_font("Monospaced Font", imgui_font_mono_data, imgui_font_mono_size, required_size);
        font_set.size = required_size;

        font_sets.push_back(font_set);
        frame_fonts = &font_sets.back();

        (void)ImGui_ImplBgfx_CreateFontsTexture();
    }
};

static FontContext* get_font_context()
{
    IM_ASSERT(ImGui::GetCurrentContext() != nullptr);

    void* font_ctx = ImGui::GetIO().BackendLanguageUserData;
    IM_ASSERT(font_ctx != nullptr);

    return reinterpret_cast<FontContext*>(font_ctx);
}

void imgui_init(GLFWwindow* window, unsigned short view_id, float font_size)
{
    IMGUI_CHECKVERSION();

    ImGui::CreateContext();

    ImGuiIO& io = ImGui::GetIO();
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
    io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;
    io.IniFilename  = nullptr;

    ImGui::StyleColorsDark();

    ImGui_ImplGlfwPatched_Init(window);
    ImGui_ImplBgfx_Init(view_id);

    FontContext* font_ctx = IM_NEW(FontContext)();
    font_ctx->active_size = font_size;

    IM_ASSERT(io.BackendLanguageUserData == nullptr);
    io.BackendLanguageUserData = font_ctx;

    float scale;
    glfwGetWindowContentScale(window, &scale, nullptr);

    font_ctx->update_frame_fonts(scale);
    io.Fonts->Build();
}

void imgui_shutdown()
{
    ImGui_ImplBgfx_Shutdown();
    ImGui_ImplGlfw_Shutdown();

    ImGui::DestroyContext();
}

void imgui_begin_frame()
{
    ImGui_ImplBgfx_NewFrame();
    ImGui_ImplGlfwPatched_NewFrame();

    FontContext* font_ctx = get_font_context();
    font_ctx->update_frame_fonts(ImGui::GetIO().DisplayFramebufferScale.x);

    ImGuiIO& io = ImGui::GetIO();
    io.FontGlobalScale = 1.0f / io.DisplayFramebufferScale.x;

    ImGui::NewFrame();
    ImGui::PushFont(font_ctx->frame_fonts->base);
}

void imgui_end_frame()
{
    ImGui::PopFont();
    ImGui::Render();

    ImGui_ImplBgfx_RenderDrawData(ImGui::GetDrawData());

    FontContext* font_ctx = get_font_context();
    font_ctx->frame_fonts = nullptr;
}


namespace ImGui
{

void SetGlobalFontSize(float font_size)
{
    if (FontContext* font_context = get_font_context())
    {
        font_context->active_size = font_size;
    }
}

float GetGlobalFontSize()
{
    if (FontContext* font_context = get_font_context())
    {
        return font_context->active_size;
    }

    return 0.0f;
}

void PushMonospacedFont()
{
    FontContext* font_context = get_font_context();

    ImGui::PushFont(font_context && font_context->frame_fonts
        ? font_context->frame_fonts->mono
        : nullptr
    );
}

} // namespace ImGui
