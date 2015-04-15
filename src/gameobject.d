module erlogtrisy2k.gameobject;

import erlogtrisy2k.component;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.memory;

import std.stdio;
import std.algorithm;
import std.string;

class NoComponent: Exception {
    this(string str) {
        super(str);
    }
}

class GameObject {
    static int GID = 0;
    int id;
    Component[] components;

    this() {
        _M.send(make!MNewObject(this));
        id = GID++;
    }
    ~this() {
        _M.send(make!MObjectDeleted(this));
        foreach(c; components) {
            unmake(c);
        }
    }

    T get(T)() {
        foreach(c; components) {
            auto a = cast(T)c;
            if (a !is null) {
                return a;
            }
        }
        throw new NoComponent(T.classinfo.name);
    }

    T getAlways(T)() {
        T c;
        try {
            c = get!T();
        }
        catch (NoComponent) {
            c = make!T();
            add(c);
        }
        return c;
    }

    void add(Component c) {
        components ~= c;
        _M.send(make!MComponentChange(this));
    }

    void remove(T)(T c) {
        components = components.remove(c);
        _M.send(make!MComponentChange(this));
    }

    bool has(string id) {
        foreach(c; components) {
            if (id == c.classinfo.name) {
                return true;
            }
        }
        return false;
    }

    bool has(T)() {
        //return (get!T() !is null);
        try {
            get!T();
            return true;
        }
        catch (NoComponent e){
            return false;
        }
    }

    override bool opEquals(Object o) {
        GameObject b = cast(GameObject)o;

        return id == b.id;
    }

    const void toString(scope void delegate(const(char)[]) sink) {
        sink(this.classinfo.name);
        sink("(");
        sink(components[0].classinfo.name);
        foreach(c; components[1..$]) {
            sink(", ");
            sink(c.classinfo.name);
        }
        sink(")");
    }
}


