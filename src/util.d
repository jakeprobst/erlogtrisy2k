module erlogtrisy2k.util;

import std.string;

static string[] expandString(string s, int b, int e) {
    string[] o;
    foreach(i; b .. e) {
        o ~= s.format(i);
    }

    return o;
}




