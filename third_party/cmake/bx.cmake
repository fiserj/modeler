set(BX_DIR ${bx_SOURCE_DIR})

add_library(bx STATIC
    ${BX_DIR}/src/amalgamated.cpp
)

target_include_directories(bx
    PUBLIC
        ${BX_DIR}/include
    PRIVATE
        ${BX_DIR}/3rdparty
)

target_compile_definitions(bx PUBLIC
    __STDC_CONSTANT_MACROS
    __STDC_FORMAT_MACROS
    __STDC_LIMIT_MACROS
    "BX_CONFIG_DEBUG=$<CONFIG:Debug>"
)

if(NOT MSVC)
    target_compile_options(bx PUBLIC
        -Wno-gnu-zero-variadic-macro-arguments
    )
else()
    # http://web.archive.org/web/20221109200607/https://learn.microsoft.com/en-us/cpp/build/reference/zc-cplusplus?view=msvc-170
    target_compile_options(bx PUBLIC
        "/Zc:__cplusplus"
    )
endif()

if(APPLE)
    target_include_directories(bx PRIVATE
        ${BX_DIR}/include/compat/osx
    )
elseif(WIN32)
    target_include_directories(bx PUBLIC
        ${BX_DIR}/include/compat/msvc
    )
endif()

if(MSVC)
    target_compile_definitions(bx PRIVATE
        _CRT_SECURE_NO_WARNINGS
    )
endif()

set_target_properties(bx PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party"
)