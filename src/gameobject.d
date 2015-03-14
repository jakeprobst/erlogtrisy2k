module erlogtrisy2k.gameobject;

import erlogtrisy2k.component;
import erlogtrisy2k.messagebus;

import std.stdio;
import std.container;
import std.algorithm;

class GameObject {
    Component[] components;

    this() {
        _M.send(new MNewObject(this));
        }
    ~this() {
        _M.send(new MObjectDeleted(this));
        foreach(c; components) {
            delete c;
        }
    }

    Component get(CType t) {
        foreach(c; components) {
            if (c.type == t) {
                return c;
            }
        }
        return null;
    }

    T get(T)() {
        foreach(c; components) {
            auto a = cast(T)c;
            if (a !is null) {
                return a;
            }
        }
        return null;
    }

    void add(Component c) {
        components ~= c;
        _M.send(new MComponentChange(this));
    }

    void remove(CType c) {
        components = components.remove(c);
    }

    bool has(CType c) {
        return (get(c) !is null);
    }
}

