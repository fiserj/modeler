macro(TURN_OFF option)
    set(${option} OFF CACHE INTERNAL "" FORCE)
endmacro()

include(FetchContent)


# ------------------------------------------------------------------------------
# BGFX
# ------------------------------------------------------------------------------

set(BGFX_GIT_TAG e87f08b1e50af8ad416e34fe7365aa5fb6fe5e37)

FetchContent_Declare(
    bgfx
    GIT_REPOSITORY https://github.com/bkaradzic/bgfx.git
    GIT_TAG        ${BGFX_GIT_TAG}
)

FetchContent_Populate(bgfx)

include(cmake/bgfx.cmake)
include(cmake/shaderc.cmake)


# ------------------------------------------------------------------------------
# BIMG
# ------------------------------------------------------------------------------

FetchContent_Declare(
    bimg
    GIT_REPOSITORY https://github.com/bkaradzic/bimg.git
    GIT_TAG        0de8816a8b155fe85583aa74f5bc93bdfb8910bb
)

FetchContent_Populate(bimg)

include(cmake/bimg.cmake)


# ------------------------------------------------------------------------------
# BX
# ------------------------------------------------------------------------------

FetchContent_Declare(
    bx
    GIT_REPOSITORY https://github.com/bkaradzic/bx.git
    GIT_TAG        32a946990745fa1a0ee5df67ad40a6d980f5b1ab
)

FetchContent_Populate(bx)

include(cmake/bx.cmake)


# ------------------------------------------------------------------------------
# CATCH2
# ------------------------------------------------------------------------------

TURN_OFF(CATCH_INSTALL_DOCS)
TURN_OFF(CATCH_INSTALL_EXTRAS)

if(WITH_CATCH2)
    FetchContent_Declare(
        Catch2
        GIT_REPOSITORY https://github.com/catchorg/Catch2.git
        GIT_TAG        v3.2.0
    )

    FetchContent_MakeAvailable(Catch2)
endif()


# ------------------------------------------------------------------------------
# FMT
# ------------------------------------------------------------------------------

TURN_OFF(FMT_MASTER_PROJECT)

if(WITH_FMT)
    FetchContent_Declare(
        fmt
        GIT_REPOSITORY https://github.com/fmtlib/fmt.git
        GIT_TAG        80f8d34427d40ec5e7ce3b10ededc46bd4bd5759
    )

    FetchContent_MakeAvailable(fmt)
endif()


# ------------------------------------------------------------------------------
# GLFW
# ------------------------------------------------------------------------------

TURN_OFF(GLFW_BUILD_DOCS)
TURN_OFF(GLFW_BUILD_EXAMPLES)
TURN_OFF(GLFW_BUILD_TESTS)
TURN_OFF(GLFW_DOCUMENT_INTERNALS)
TURN_OFF(GLFW_INSTALL)

FetchContent_Declare(
    glfw
    GIT_REPOSITORY https://github.com/glfw/glfw.git
    GIT_TAG        dd8a678a66f1967372e5a5e3deac41ebf65ee127
)

FetchContent_MakeAvailable(glfw)

set_target_properties(
    glfw
    update_mappings
    PROPERTIES
    FOLDER "Third Party/GLFW3"
)


# ------------------------------------------------------------------------------
# DEAR IMGUI
# ------------------------------------------------------------------------------

if(WITH_IMGUI)
    FetchContent_Declare(
        imgui
        GIT_REPOSITORY https://github.com/ocornut/imgui.git
        GIT_TAG        69beaa1d0b7fc8f4b448dcf1780b08cfc959da65 # docking branch
    )

    FetchContent_Populate(imgui)

    include(cmake/imgui.cmake)
endif()


# ------------------------------------------------------------------------------
# GLEQ
# ------------------------------------------------------------------------------

if(WITH_GLEQ)
    FetchContent_Declare(
        gleq
        GIT_REPOSITORY https://github.com/glfw/gleq.git
        GIT_TAG        4dd5070341fa17856d06a38f948a100df2fc34cd
    )

    FetchContent_Populate(gleq)

    include(cmake/gleq.cmake)
endif()


# ------------------------------------------------------------------------------
# LUAU
# ------------------------------------------------------------------------------

TURN_OFF(LUAU_BUILD_CLI)
TURN_OFF(LUAU_BUILD_TESTS)

if(WITH_LUAU)
    FetchContent_Declare(
        Luau
        GIT_REPOSITORY https://github.com/Roblox/luau.git
        GIT_TAG        0.556
    )

    FetchContent_MakeAvailable(Luau)

    set_target_properties(
        isocline
        Luau.Analysis
        Luau.Ast
        Luau.CodeGen
        Luau.Common
        Luau.Compiler
        Luau.VM
        PROPERTIES
        FOLDER "third_party/Luau"
    )
endif()


# ------------------------------------------------------------------------------
# MESHOPTIMIZER
# ------------------------------------------------------------------------------

if(WITH_MESHOPT)
    FetchContent_Declare(
        meshoptimizer
        GIT_REPOSITORY https://github.com/zeux/meshoptimizer.git
        GIT_TAG        c4cfc3581f37ae70fa274bef37584a588ae266ab
    )

    FetchContent_Populate(meshoptimizer)

    include(cmake/meshoptimizer.cmake)
endif()


# ------------------------------------------------------------------------------
# STB
# ------------------------------------------------------------------------------

if(WITH_STB)
    FetchContent_Declare(
        stb
        GIT_REPOSITORY https://github.com/nothings/stb.git
        GIT_TAG        8b5f1f37b5b75829fc72d38e7b5d4bcbf8a26d55
    )

    FetchContent_Populate(stb)

    include(cmake/stb.cmake)
endif()