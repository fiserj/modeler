set(IMGUI_DIR ${imgui_SOURCE_DIR})

add_library(imgui STATIC
    ${IMGUI_DIR}/imgui.cpp
    ${IMGUI_DIR}/imgui.h
    ${IMGUI_DIR}/imgui_demo.cpp
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp
    ${IMGUI_DIR}/backends/imgui_impl_glfw.h
    src/imgui_impl_glfw_patched.cpp
    src/imgui_impl_glfw_patched.h
    src/imgui_draw_patched.cpp
    src/imgui_impl_bgfx.cpp
    src/imgui_impl_bgfx.h
)

target_include_directories(imgui
    PRIVATE
        "${CMAKE_BINARY_DIR}/shaders" # TODO : Replace with target dependency.
    PUBLIC
        ${IMGUI_DIR}
        ${IMGUI_DIR}/backends
        src
)

target_link_libraries(imgui PUBLIC
    bgfx
    glfw
)

target_compile_definitions(imgui PUBLIC
    WITH_IMGUI
)

set_target_properties(imgui PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party"
)

include(../src/cmake/add_shader_dependency.cmake)

set(IMGUI_SHADER_DIR "${CMAKE_BINARY_DIR}/third_party/imgui/shaders")

add_shader_dependency(imgui "../src/imgui.vs" "../src/varying.def.sc" "${IMGUI_SHADER_DIR}")
add_shader_dependency(imgui "../src/imgui.fs" "../src/varying.def.sc" "${IMGUI_SHADER_DIR}")