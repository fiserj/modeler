cmake_minimum_required(VERSION 3.20)

project(Modeler)

set(WITH_IMGUI ON)
set(WITH_PREBUILT_SHADERC ON)

add_subdirectory(third_party)
add_subdirectory(src)