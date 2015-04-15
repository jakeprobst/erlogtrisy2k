module erlogtrisy2k.memory;

import std.stdio;
import std.conv;
import core.memory;
import core.stdc.stdlib;
import core.exception;


string[void*] unfreedvars;

static ~this() {
    writeln("unfreed variables:");
    foreach(p, s; unfreedvars) {
        writefln("%s at %X", s, p);
    }
}

T make(T, Args...)(Args args) {
    size_t size = __traits(classInstanceSize, T);
    void* obj = core.stdc.stdlib.malloc(size);
    GC.addRange(obj, size);
    if (!obj) {
        throw new OutOfMemoryError();
    }

    unfreedvars[obj] = T.classinfo.name;
    return emplace!(T, Args)(obj[0..size], args);
}

void unmake(T)(T obj) {
    unfreedvars.remove(cast(void*)obj);
    destroy(obj);
    GC.removeRange(cast(void*)obj);
    core.stdc.stdlib.free(cast(void*)obj);
}
