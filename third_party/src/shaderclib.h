#pragma once

namespace bgfx { struct ShaderHandle; }

namespace shaderc
{

enum struct ShaderType
{
    COMPUTE,
    FRAGMENT,
    VERTEX,
};

bgfx::ShaderHandle compile_from_memory
(
    ShaderType  type,
    const char* source,
    const char* varying
);

} // shaderc
