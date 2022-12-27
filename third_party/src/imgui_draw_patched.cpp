#include <imgui_draw.cpp>

#ifndef IMGUI_ENABLE_STB_TRUETYPE
#   error ImGui doesn't seem to be using stb_truetype library.
#endif

// Font size is inconsistent (see https://tonsky.me/blog/font-size/), so we're
// using cap size to display text with predictable size.
extern float get_font_size_for_cap_size(const void* font_data, float cap_pixel_size)
{
    stbtt_fontinfo info = {};
    info.data = const_cast<unsigned char*>(reinterpret_cast<const unsigned char*>(font_data));
    info.hhea = stbtt__find_table(info.data, info.fontstart, "hhea");

    const int table = stbtt__find_table(info.data, info.fontstart, "OS/2");
    if (!table || ttUSHORT(info.data + table) < 2) // Version.
    {
        // TODO : Maybe estimate cap height from capital "H" bounding box?
        return 0.0f;
    }

    const stbtt_int16 cap_height = ttSHORT(info.data + table + 88); // sCapHeight.
    IM_ASSERT(cap_height > 0);

    int ascent, descent;
    stbtt_GetFontVMetrics(&info, &ascent, &descent, nullptr);

    return (ascent - descent) * cap_pixel_size / cap_height;
}
