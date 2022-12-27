# Starter Template
A graphics application starter package.

## Libraries

### Required
* [bgfx](https://github.com/bkaradzic/bgfx/tree/e87f08b1e50af8ad416e34fe7365aa5fb6fe5e37)
* [bimg](https://github.com/bkaradzic/bimg/tree/0de8816a8b155fe85583aa74f5bc93bdfb8910bb)
* [bx](https://github.com/bkaradzic/bx/tree/32a946990745fa1a0ee5df67ad40a6d980f5b1ab)
* [GLFW](https://github.com/glfw/glfw/tree/dd8a678a66f1967372e5a5e3deac41ebf65ee127)

### Optional
To enable an optional library, go to [CMakeLists.txt](CMakeLists.txt) and set
the applicable `WITH_...` variable to `ON`.

| Library | CMake Option |
| ------------- | ------------- |
| [Catch2](https://github.com/catchorg/Catch2/tree/65cc7fd2ae39a7a543767f661b096d7d521ee4f0) | `WITH_CATCH2` |
| [Dear ImGui](https://github.com/ocornut/imgui/tree/69beaa1d0b7fc8f4b448dcf1780b08cfc959da65) | `WITH_IMGUI` |
| [{fmt}](https://github.com/fmtlib/fmt/commit/80f8d34427d40ec5e7ce3b10ededc46bd4bd5759) | `WITH_FMT` |
| [GLEQ](https://github.com/glfw/gleq/tree/4dd5070341fa17856d06a38f948a100df2fc34cd) | `WITH_GLEQ` |
| [meshoptimizer](https://github.com/zeux/meshoptimizer/tree/c4cfc3581f37ae70fa274bef37584a588ae266ab) | `WITH_MESHOPT` |
| [stb](https://github.com/nothings/stb/commit/8b5f1f37b5b75829fc72d38e7b5d4bcbf8a26d55) | `WITH_STB` |

#### shaderc
BGFX's `shaderc` compiler can take a relatively long time to compile. When
`WITH_PREBUILT_SHADERC` is `ON` (which it is by default), CMake tries to fetch
prebuilt binary for your platform (currently Windows and macOS x64), and only
compiles `shaderc` from source otherwise. You can pass CMake
`WITH_PREBUILT_SHADERC=OFF` to always force compilation from source.