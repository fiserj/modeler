set(NAME ${CMAKE_PROJECT_NAME})

set(SOURCE_LIST "")

if(APPLE)
    list(APPEND SOURCE_LIST main.mm)
else()
    list(APPEND SOURCE_LIST main.cpp)
endif()

set(LIBRARY_LIST
    bgfx
    glfw
)

if(WITH_FMT)
    list(APPEND LIBRARY_LIST fmt)
endif()

if(WITH_GLEQ)
    list(APPEND LIBRARY_LIST gleq)
endif()

if(WITH_IMGUI)
    list(APPEND SOURCE_LIST imgui.cpp)
    list(APPEND LIBRARY_LIST imgui)
endif()

if(WITH_LUAU)
    list(APPEND LIBRARY_LIST Luau.CodeGen Luau.Compiler Luau.VM)
endif()

if(WITH_MESHOPT)
    list(APPEND LIBRARY_LIST meshoptimizer)
endif()

if(WITH_STB)
    list(APPEND LIBRARY_LIST stb)
endif()

if(WITH_SHADERC_LIBRARY)
    list(APPEND LIBRARY_LIST shaderclib)
endif()

add_executable(${NAME}
    ${SOURCE_LIST}
)

target_link_libraries(${NAME} PRIVATE
    ${LIBRARY_LIST}
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