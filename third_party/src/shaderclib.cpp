#include "shaderclib.h"

#include <string>
#include <vector>            // vector

#include <bgfx/bgfx.h>       // copy, createShader

#include <shaderc.h>         // Options

#include <bgfx_shader_str.h> // s_bgfx_shader_str

namespace bgfx
{

bool compileShader(const char*, const char*, char*, uint32_t, Options&, bx::WriterI*);

} // namespace bgfx

namespace shaderc
{

struct BufferWriter : public bx::FileWriter, public std::vector<uint8_t>
{
public:
	virtual ~BufferWriter() {}

	virtual int32_t write(const void* data, int32_t size, bx::Error*) override
	{
		const char* start = static_cast<const char*>(data);
		insert(end(), start, start + size);

		return size;
	}
};

bgfx::ShaderHandle compile_from_memory
(
    ShaderType  type,
    const char* source,
    const char* varying
)
{
    bgfx::Options options;
    options.shaderType     = "cfv"[int(type)];
    options.inputFilePath  = "<in_memory>";
    options.outputFilePath = "";
#if BX_PLATFORM_OSX
    options.platform = "osx";
    options.profile  = "metal";
#elif BX_PLATFORM_WINDOWS
    options.platform = "windows";
    options.profile  = "cpv"[int(type)] + std::string("s_5_0");
#else
#   error Unsupported platform.
#endif

    std::string patched = source;
    patched += '\n';

    const std::string search = "#include <bgfx_shader.sh>";
    const size_t      index  = patched.find(search);
    if (index != std::string::npos)
    {
        patched.replace(index, search.length(), s_bgfx_shader_str);
    }

    constexpr size_t pad = 16384;
    char* data = new char[patched.length() + pad];
    bx::memCopy(data, patched.c_str(), patched.length());
    bx::memSet(&data[patched.length()], 0, pad);

    BufferWriter writer;
    if (!bgfx::compileShader(
        varying,
        "",
        data,
        patched.length() - 1,
        options,
        &writer
    ))
    {
        return BGFX_INVALID_HANDLE;
    }

    return bgfx::createShader(bgfx::copy(writer.data(), writer.size()));
}

} // namespace shaderc
