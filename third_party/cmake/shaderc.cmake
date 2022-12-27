set(SHADERC_RELATIVE_TOOL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../tools/shaderc")
get_filename_component(SHADERC_TOOL_DIR ${SHADERC_RELATIVE_TOOL_DIR} ABSOLUTE)

set(PREBUILT_SHADERC_AVAILABLE OFF)

if(WITH_PREBUILT_SHADERC)
    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64" OR
        CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "AMD64" OR
        CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "amd64")
        set(PREBUILT_SHADERC_BRANCH "x64")
    else()
        set(PREBUILT_SHADERC_BRANCH "unsupported")
    endif()

    if(APPLE)
        string(PREPEND PREBUILT_SHADERC_BRANCH "macos-")
    elseif(WIN32)
        string(PREPEND PREBUILT_SHADERC_BRANCH "windows-")
    endif()

    if(PREBUILT_SHADERC_BRANCH MATCHES "^(macos-x64|windows-x64)$")
        message(STATUS "Prebuilt shaderc binary available.")
        set(PREBUILT_SHADERC_AVAILABLE ON)

        FetchContent_Declare(
            shaderc_prebuilt
            GIT_REPOSITORY https://github.com/fiserj/starter-tools.git
            GIT_TAG        "shaderc-${PREBUILT_SHADERC_BRANCH}-${BGFX_GIT_TAG}"
        )

        FetchContent_Populate(shaderc_prebuilt)
    else()
        message(WARNING "Prebuilt shaderc binary unavailable; will be built from source.")
    endif()
endif() # WITH_PREBUILT_SHADERC

if(APPLE)
    set(SHADERC_TOOL_OUTPUT_BINARY "${SHADERC_TOOL_DIR}/osx/shaderc")
elseif(WIN32)
    set(SHADERC_TOOL_OUTPUT_BINARY "${SHADERC_TOOL_DIR}/windows/shaderc.exe")
endif()

if(PREBUILT_SHADERC_AVAILABLE)
    get_filename_component(SHADERC_TOOL_NAME ${SHADERC_TOOL_OUTPUT_BINARY} NAME)

    add_custom_command(
        OUTPUT ${SHADERC_TOOL_OUTPUT_BINARY}
        COMMAND ${CMAKE_COMMAND} -E copy "${shaderc_prebuilt_SOURCE_DIR}/${SHADERC_TOOL_NAME}" ${SHADERC_TOOL_OUTPUT_BINARY}
    )

    add_custom_target(shaderc
        DEPENDS ${SHADERC_TOOL_OUTPUT_BINARY}
    )
endif()

if(NOT PREBUILT_SHADERC_AVAILABLE OR WITH_SHADERC_LIBRARY)
    include(cmake/shaderclib.cmake)
endif()