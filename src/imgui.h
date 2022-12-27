#pragma once

#include <imgui.h> // ImGui::*

struct GLFWwindow;

namespace ImGui
{

void SetGlobalFontSize(float font_size);

float GetGlobalFontSize();

void PushMonospacedFont();

} // namespace ImGui

void imgui_init(GLFWwindow* window, unsigned short view_id, float font_size = 8.0f);

void imgui_shutdown();

void imgui_begin_frame();

void imgui_end_frame();
