module erlogtrisy2k.util;

import std.string;
import std.conv;

struct Color {
    ubyte r,g,b;
    this(int x, int y, int z) {
        r = cast(ubyte)x;
        g = cast(ubyte)y;
        b = cast(ubyte)z;
    }

    this(ubyte x, ubyte y, ubyte z) {
        r = x;
        g = y;
        b = z;
    }
}




static string[] expandString(string s, int b, int e) {
    string[] o;
    foreach(i; b .. e) {
        o ~= s.format(i);
    }

    return o;
}




