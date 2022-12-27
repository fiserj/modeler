set(BGFX_DIR ${bgfx_SOURCE_DIR})

if(APPLE)
    add_library(bgfx STATIC
        ${BGFX_DIR}/src/amalgamated.mm
    )
else()
    add_library(bgfx STATIC
        ${BGFX_DIR}/src/amalgamated.cpp
    )
endif()

target_include_directories(bgfx
    PUBLIC
        ${BGFX_DIR}/include
    PRIVATE
        ${BGFX_DIR}/3rdparty/khronos
)

if(WIN32)
    target_include_directories(bgfx PRIVATE
        ${BGFX_DIR}/3rdparty/directx-headers/include/directx
    )
endif()

if(APPLE)
    target_link_libraries(bgfx PUBLIC
        "-framework AppKit"
        "-framework Foundation"
        "-framework Metal"
        "-framework QuartzCore"
    )

    target_compile_definitions(bgfx PRIVATE
        BGFX_CONFIG_RENDERER_METAL
    )
elseif(UNIX)
    # TODO : Check linking issues.

    target_compile_definitions(bgfx PRIVATE
        BGFX_CONFIG_RENDERER_VULKAN
    )
elseif(WIN32)
    target_include_directories(bgfx PRIVATE
            ${BGFX_DIR}/3rdparty
            ${BGFX_DIR}/3rdparty/directx-headers/include
    )

    target_compile_definitions(bgfx PRIVATE
        BGFX_CONFIG_RENDERER_DIRECT3D12
    )
endif()

if (MSVC)
    target_compile_definitions(bgfx PRIVATE
        _CRT_SECURE_NO_WARNINGS
    )
endif()

target_link_libraries(bgfx
    PRIVATE
        bimg
    PUBLIC
        bx
)

set_target_properties(bgfx PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party"
)

add_dependencies(bgfx shaderc)

set(bgfx_SOURCE_DIR "${bgfx_SOURCE_DIR}" PARENT_SCOPE)