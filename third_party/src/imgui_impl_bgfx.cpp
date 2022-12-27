#include "imgui_impl_bgfx.h"

#include <math.h>                 // fmaxf, fminf
#include <stddef.h>               // size_t
#include <stdint.h>               // UINT16_MAX, uint*_t
#include <string.h>               // memcpy

#include <bgfx/bgfx.h>            // bgfx::*
#include <bgfx/embedded_shader.h> // BGFX_EMBEDDED_SHADER

#include <imgui.h>                // GetCurrentContext, GetIO

#include <src/imgui_fs.h>        // imgui_fs_*
#include <src/imgui_vs.h>        // imgui_vs_

struct ImGui_ImplBgfx_Data
{
    bgfx::VertexLayout  layout;
    bgfx::ProgramHandle program = BGFX_INVALID_HANDLE;
    bgfx::UniformHandle sampler = BGFX_INVALID_HANDLE;
    bgfx::TextureHandle texture = BGFX_INVALID_HANDLE;
    bgfx::ViewId        view_id;
};

static ImGui_ImplBgfx_Data* ImGui_ImplBgfx_GetBackendData()
{
    IM_ASSERT(ImGui::GetCurrentContext() != nullptr);

    void* bd = ImGui::GetIO().BackendRendererUserData;
    IM_ASSERT(bd != nullptr);

    return reinterpret_cast<ImGui_ImplBgfx_Data*>(bd);
}

bool ImGui_ImplBgfx_Init(unsigned short view_id)
{
    IM_ASSERT(view_id < bgfx::getCaps()->limits.maxViews);

    ImGuiIO& io = ImGui::GetIO();
    IM_ASSERT(io.BackendRendererUserData == nullptr);

    ImGui_ImplBgfx_Data* bd = IM_NEW(ImGui_ImplBgfx_Data)();
    io.BackendRendererUserData = bd;
    io.BackendRendererName     = "imgui_impl_bgfx";

    bd->view_id = bgfx::ViewId(view_id);
    bd->layout
        .begin()
        .add(bgfx::Attrib::Position , 2, bgfx::AttribType::Float)
        .add(bgfx::Attrib::TexCoord0, 2, bgfx::AttribType::Float)
        .add(bgfx::Attrib::Color0   , 4, bgfx::AttribType::Uint8, true)
        .end();

    return true;
}

void ImGui_ImplBgfx_Shutdown()
{
    ImGui_ImplBgfx_DestroyDeviceObjects();

    ImGui_ImplBgfx_Data* bd = ImGui_ImplBgfx_GetBackendData();
    IM_DELETE(bd);

    ImGuiIO& io = ImGui::GetIO();
    io.BackendRendererUserData = nullptr;
    io.BackendRendererName     = nullptr;
}

void ImGui_ImplBgfx_NewFrame()
{
    const ImGui_ImplBgfx_Data* bd = ImGui_ImplBgfx_GetBackendData();

    if (!bgfx::isValid(bd->program))
    {
        (void)ImGui_ImplBgfx_CreateDeviceObjects();
    }
}

void ImGui_ImplBgfx_RenderDrawData(ImDrawData* draw_data)
{
    const ImGuiIO& io = ImGui::GetIO();
    const float width  = io.DisplaySize.x * io.DisplayFramebufferScale.x;
    const float height = io.DisplaySize.y * io.DisplayFramebufferScale.y;

    const ImGui_ImplBgfx_Data* bd = ImGui_ImplBgfx_GetBackendData();
    bgfx::setViewName(bd->view_id, "ImGui");
    bgfx::setViewMode(bd->view_id, bgfx::ViewMode::Sequential);

    {
        const float L = draw_data->DisplayPos.x;
        const float R = draw_data->DisplayPos.x + draw_data->DisplaySize.x;
        const float T = draw_data->DisplayPos.y;
        const float B = draw_data->DisplayPos.y + draw_data->DisplaySize.y;

        const float ortho[4][4] =
        {
            { 2.0f / (R - L)   , 0.0f             ,  0.0f, 0.0f },
            { 0.0f             , 2.0f / (T - B)   ,  0.0f, 0.0f },
            { 0.0f             , 0.0f             , -1.0f, 0.0f },
            { (R + L) / (L - R), (T + B) / (B - T),  0.0f, 1.0f },
        };

        bgfx::setViewRect     (bd->view_id, 0, 0, uint16_t(width), uint16_t(height));
        bgfx::setViewTransform(bd->view_id, nullptr, ortho);
    }

    for (int i = 0; i < draw_data->CmdListsCount; i++)
    {
        const ImDrawList* draw_list = draw_data->CmdLists[i];

        bgfx::TransientVertexBuffer vertices;
        bgfx::TransientIndexBuffer  indices;
        if (!bgfx::allocTransientBuffers(
            &vertices,
            bd->layout,
            uint32_t(draw_list->VtxBuffer.size()),
            &indices,
            uint32_t(draw_list->IdxBuffer.size())
        ))
        {
            IM_ASSERT(false && "Failed to allocate buffers for ImGui geometry.");
            return;
        }

        memcpy(vertices.data, draw_list->VtxBuffer.begin(), size_t(draw_list->VtxBuffer.size_in_bytes()));
        memcpy(indices .data, draw_list->IdxBuffer.begin(), size_t(draw_list->IdxBuffer.size_in_bytes()));

        for (int j = 0; j < draw_list->CmdBuffer.size(); j++)
        {
            const ImDrawCmd& cmd = draw_list->CmdBuffer[j];

            if (cmd.UserCallback != nullptr)
            {
                cmd.UserCallback(draw_list, &cmd);
            }
            else if (cmd.ElemCount)
            {
                const ImVec4 rect  = cmd.ClipRect;
                const ImVec2 scale = io.DisplayFramebufferScale;

                const uint16_t x(fmaxf(rect.x * scale.x, 0.0f));
                const uint16_t y(fmaxf(rect.y * scale.y, 0.0f));
                const uint16_t w(fminf(rect.z * scale.x, float(UINT16_MAX)) - x);
                const uint16_t h(fminf(rect.w * scale.y, float(UINT16_MAX)) - y);

                const bgfx::TextureHandle texture = cmd.GetTexID() != nullptr
                    ? bgfx::TextureHandle{uint16_t(uintptr_t(cmd.GetTexID()))}
                    : bd->texture;

                constexpr uint64_t state =
                    BGFX_STATE_WRITE_RGB   |
                    BGFX_STATE_WRITE_A     |
                    BGFX_STATE_BLEND_ALPHA ;

                bgfx::setState(state);
                bgfx::setScissor(x, y, w, h);
                bgfx::setTexture(0, bd->sampler, texture);
                bgfx::setVertexBuffer(0, &vertices);
                bgfx::setIndexBuffer(&indices, cmd.IdxOffset, cmd.ElemCount);

                bgfx::submit(bd->view_id, bd->program);
            }
        } // draw_list->CmdBuffer.size()
    } // draw_data->CmdListsCount
}

bool ImGui_ImplBgfx_CreateFontsTexture()
{
    uint8_t* data;
    int      width, height;
    ImGui::GetIO().Fonts->GetTexDataAsRGBA32(&data, &width, &height);

    ImGui_ImplBgfx_Data* bd = ImGui_ImplBgfx_GetBackendData();
    bd->texture = bgfx::createTexture2D(
        uint16_t(width),
        uint16_t(height),
        false,
        1,
        bgfx::TextureFormat::RGBA8,
        0,
        bgfx::copy(data, uint32_t(width) * uint32_t(height) * 4)
    );
    IM_ASSERT(bgfx::isValid(bd->texture));

    return bgfx::isValid(bd->texture);
}

void ImGui_ImplBgfx_DestroyFontsTexture()
{
    ImGui_ImplBgfx_Data* bd = ImGui_ImplBgfx_GetBackendData();

    if (bgfx::isValid(bd->texture))
    {
        bgfx::destroy(bd->texture);
    }
}

bool ImGui_ImplBgfx_CreateDeviceObjects()
{
    ImGui_ImplBgfx_Data* bd = ImGui_ImplBgfx_GetBackendData();

    if (!bgfx::isValid(bd->texture))
    {
        ImGui_ImplBgfx_CreateFontsTexture();
    }

    bd->sampler = bgfx::createUniform("s_texture", bgfx::UniformType::Sampler);
    IM_ASSERT(bgfx::isValid(bd->sampler));

    const bgfx::EmbeddedShader shaders[] =
    {
        BGFX_EMBEDDED_SHADER(imgui_fs),
        BGFX_EMBEDDED_SHADER(imgui_vs),

        BGFX_EMBEDDED_SHADER_END()
    };
    bd->program = bgfx::createProgram(
        bgfx::createEmbeddedShader(shaders, bgfx::getRendererType(), "imgui_vs"),
        bgfx::createEmbeddedShader(shaders, bgfx::getRendererType(), "imgui_fs"),
        true
    );
    IM_ASSERT(bgfx::isValid(bd->program));

    return
        bgfx::isValid(bd->program) &&
        bgfx::isValid(bd->sampler) &&
        bgfx::isValid(bd->texture);
}

void ImGui_ImplBgfx_DestroyDeviceObjects()
{
    ImGui_ImplBgfx_DestroyFontsTexture();

    ImGui_ImplBgfx_Data* bd = ImGui_ImplBgfx_GetBackendData();

    if (bgfx::isValid(bd->program))
    {
        bgfx::destroy(bd->program);
    }

    if (bgfx::isValid(bd->sampler))
    {
        bgfx::destroy(bd->sampler);
    }
}
