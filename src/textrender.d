module erlogtrisy2k.textrender;

import erlogtrisy2k.gameobject;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.util;

import derelict.freetype.ft;
import derelict.sdl2.sdl;

import std.stdio;
import std.utf;
import std.string;



const string DEFAULTFONT = "resources/default.ttf";
//const int DEFAULTSIZE = 12;
const int POINTTOPIXEL = 64; // 64 point = 1 px

struct GlyphCache {
    ubyte data[];
    int w, h;
    long xadvance;
    int left, top;

    this(FT_GlyphSlot glyph) {
        FT_Bitmap bmp = glyph.bitmap;
        w = bmp.width;
        h = bmp.rows;

        left = glyph.bitmap_left;
        top = glyph.bitmap_top;
        xadvance = glyph.advance.x/POINTTOPIXEL;

        for(int i = 0; i < w*h; i++) {
            data ~= bmp.buffer[i];
        }
    }
}

class FontCache {
    FT_Library library;
    FT_Face face;
    GlyphCache[wchar][int] cache; // cache[size][character]


    this() {
        DerelictFT.load();

        FT_Init_FreeType(&library);
        FT_New_Face(library, DEFAULTFONT.toStringz(), 0, &face);
    }
    ~this() {
    }

    int getHeight(int size) {
        FT_Set_Pixel_Sizes(face, 0, size);
        return cast(int)((face.size.metrics.height-face.size.metrics.descender) / POINTTOPIXEL);
    }

    int getStringWidth(wstring str, int size) {
        FT_Set_Pixel_Sizes(face, 0, size);
        int o;
        foreach(c; str) {
            o += getGlyph(c, size).xadvance;
        }
        return o;
    }

    GlyphCache getGlyph(wchar chr, int size) {
        try {
            GlyphCache gc = cache[size][chr];
            return gc;
        }
        catch (RangeError e) {
            FT_Set_Pixel_Sizes(face, 0, size);
            auto glyphindex = FT_Get_Char_Index(face, chr);
            FT_Load_Glyph(face, glyphindex, FT_LOAD_DEFAULT);
            FT_Render_Glyph(face.glyph, FT_RENDER_MODE_NORMAL);

            GlyphCache glyphcache = GlyphCache(face.glyph);

            cache[size][chr] = glyphcache;
            return glyphcache;
        }
    }
}


class TextRender {
    int size = 12;
    Color color = Color(0,0,0);

    this(int s, Color c) {
        size = s;
        color = c;
    }

    ~this() {
    }


    ubyte[] colorText(ubyte[] data, Color c) {
        ubyte[] outbuf;
        foreach(d; data) {
            outbuf ~= d;
            outbuf ~= c.b;
            outbuf ~= c.g;
            outbuf ~= c.r;
        }
        return outbuf;
    }



    void render(GameObject o, string str) {
        auto utf = str.toUTF16();
        CTexture tex = o.getAlways!CTexture();
        o.getAlways!CPosition();

        int width = _F.getStringWidth(utf, size);
        int height = _F.getHeight(size);
        int xoffset = 0;

        ubyte[] data = new ubyte[height*width];

        foreach(c; utf) {
            GlyphCache glyph = _F.getGlyph(c, size);
            for(int x = 0; x < glyph.w; x++) {
                for(int y = 0; y < glyph.h; y++) {
                    int px = x + glyph.left + xoffset;
                    int py = y - glyph.top + size;

                    if (py < 0 || py >= height || px < 0 || px >= width) {
                        continue;
                    }
                    data[py*width + px] = glyph.data[y*glyph.w + x];

                }
            }
            xoffset += glyph.xadvance;
        }

        tex.texture = _T.makeTexture(colorText(data, color), width, height);
    }
}












private FontCache _F;
static this() {
    _F = new FontCache();
}



