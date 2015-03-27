module erlogtrisy2k.gameobject;

import erlogtrisy2k.component;
import erlogtrisy2k.messagebus;

import std.stdio;
import std.container;
import std.algorithm;

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
        _M.send(new MNewObject(this));
        id = GID++;
    }
    ~this() {
        _M.send(new MObjectDeleted(this));
        foreach(c; components) {
            delete c;
        }
    }

    T get(T)() {
        foreach(c; components) {
            auto a = cast(T)c;
            if (a !is null) {
                return a;
            }
        }
        //return null;
        throw new NoComponent(T.classinfo.name);
        //return null;
    }

    T getAlways(T)() {
        T c;
        try {
            c = get!T();
        }
        catch (NoComponent) {
            c = new T();
            add(c);
        }
        return c;
    }

    void add(Component c) {
        components ~= c;
        _M.send(new MComponentChange(this));
    }

    void remove(T)(T c) {
        components = components.remove(c);
        _M.send(new MComponentChange(this));
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
}


