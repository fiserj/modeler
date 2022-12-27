cmake_minimum_required(VERSION 3.20)

project(StarterTemplate)

option(WITH_CATCH2 "Build with Catch2 library" OFF)
option(WITH_FMT "Build with {fmt} library" OFF)
option(WITH_GLEQ "Build with GLEQ library" OFF)
option(WITH_IMGUI "Build with Dear ImGui library" OFF)
option(WITH_LUAU "Build with Luau library" OFF)
option(WITH_MESHOPT "Build with meshoptimizer library" OFF)
option(WITH_STB "Build with stb libraries" OFF)
option(WITH_PREBUILT_SHADERC "Attempt to download prebuilt BGFX shader compiler" ON)
option(WITH_SHADERC_LIBRARY "Build BGFX shader compiler as a library" OFF)

add_subdirectory(third_party)
add_subdirectory(src)