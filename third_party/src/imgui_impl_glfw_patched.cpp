#include "imgui_impl_glfw_patched.h"

#include <math.h>              // fabsf

#include <imgui_impl_glfw.cpp> // ImGui_ImplGlfw_*

#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>        // glfw*

static void ImGui_ImplGlfwPatched_CursorPosCallback(GLFWwindow* window, double x, double y)
{
    const ImGui_ImplGlfw_Data* bd = ImGui_ImplGlfw_GetBackendData();
    IM_ASSERT(bd != nullptr);
    IM_ASSERT(bd->InstalledCallbacks == true);
    IM_ASSERT(bd->Window == window);

    if (static_cast<int>(bd->ClientApi) == -1)
    {
        const ImVec2 scale = ImGui::GetIO().DisplayFramebufferScale;

        x /= scale.x;
        y /= scale.y;
    }

    ImGui_ImplGlfw_CursorPosCallback(window, x, y);
}

static void ImGui_ImplGlfwPatched_UpdateScaleInfo()
{
    ImGui_ImplGlfw_Data* bd = ImGui_ImplGlfw_GetBackendData();
    IM_ASSERT(bd != nullptr);

    int window_size[2];
    glfwGetWindowSize(bd->Window, &window_size[0], &window_size[1]);

    int framebuffer_size[2];
    glfwGetFramebufferSize(bd->Window, &framebuffer_size[0], &framebuffer_size[1]);

    float content_scale[2];
    glfwGetWindowContentScale(bd->Window, &content_scale[0], &content_scale[1]);

    ImGuiIO& io = ImGui::GetIO();
    bool scale_cursor = false;

    for (int i = 0; i < 2; i++)
    {
        const float diff = fabsf(window_size[i] * content_scale[i] - framebuffer_size[i]);
        float retina_size;

        if (diff < 1.0f)
        {
            retina_size  = window_size[i];
        }
        else
        {
            retina_size  = framebuffer_size[i] / content_scale[i];
            scale_cursor = true;
        }

        io.DisplaySize[i] = retina_size;
        io.DisplayFramebufferScale[i] = content_scale[i];
    }

    bd->ClientApi = static_cast<GlfwClientApi>(scale_cursor ? -1 : 0);
}

bool ImGui_ImplGlfwPatched_Init(GLFWwindow* window)
{
    if (!ImGui_ImplGlfw_InitForOther(window, true))
    {
        return false;
    }

    ImGui_ImplGlfwPatched_UpdateScaleInfo();

    glfwSetCursorPosCallback(window, ImGui_ImplGlfwPatched_CursorPosCallback);

    return true;
}

void ImGui_ImplGlfwPatched_NewFrame()
{
    ImGui_ImplGlfwPatched_UpdateScaleInfo();

    ImGui_ImplGlfw_Data* bd = ImGui_ImplGlfw_GetBackendData();
    IM_ASSERT(bd != nullptr);

    if (bd->WantUpdateMonitors)
    {
        ImGui_ImplGlfw_UpdateMonitors();
    }

    ImGuiIO& io = ImGui::GetIO();

    const double current_time = glfwGetTime();
    io.DeltaTime = bd->Time > 0.0
        ? float(current_time - bd->Time)
        : float(1.0f / 60.0f);
    bd->Time = current_time;

    ImGui_ImplGlfw_UpdateMouseData  ();
    ImGui_ImplGlfw_UpdateMouseCursor();
    ImGui_ImplGlfw_UpdateGamepads   ();
}
