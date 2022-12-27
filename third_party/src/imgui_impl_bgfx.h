#pragma once

struct ImDrawData;

bool ImGui_ImplBgfx_Init(unsigned short view_id);

void ImGui_ImplBgfx_Shutdown();

void ImGui_ImplBgfx_NewFrame();

void ImGui_ImplBgfx_RenderDrawData(ImDrawData* draw_data);

bool ImGui_ImplBgfx_CreateFontsTexture();

void ImGui_ImplBgfx_DestroyFontsTexture();

bool ImGui_ImplBgfx_CreateDeviceObjects();

void ImGui_ImplBgfx_DestroyDeviceObjects();
