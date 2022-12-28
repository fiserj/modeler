set(NAME ${CMAKE_PROJECT_NAME})

set(SOURCE_LIST
    imgui.cpp
)

if(APPLE)
    list(APPEND SOURCE_LIST main.mm)
else()
    list(APPEND SOURCE_LIST main.cpp)
endif()

add_executable(${NAME}
    ${SOURCE_LIST}
)

target_link_libraries(${NAME} PRIVATE
    bgfx
    bx
    glfw
    glm
    imgui
    imguizmo
)

if(MSVC)
    target_compile_definitions(${NAME} PRIVATE
        _CRT_SECURE_NO_WARNINGS
    )

    target_compile_options(${NAME} PRIVATE
        /Wall
    )
else()
    target_compile_options(${NAME} PRIVATE
        -Wall
        -Wextra
        -Wpedantic
    )
endif()

set_target_properties(${NAME} PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    DEBUG_POSTFIX "_d"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin$<$<CONFIG:Debug>:>"
)

include(cmake/add_shader_dependency.cmake)

add_shader_dependency(${NAME} "shaders/position_color.vs")
add_shader_dependency(${NAME} "shaders/position_color.fs")