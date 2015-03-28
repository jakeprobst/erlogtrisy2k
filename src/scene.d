module erlogtrisy2k.scene;

import erlogtrisy2k.engine;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.messagebus;

import std.stdio;
import std.algorithm;



class Scene {
    Engine engine;
    GameObject[] objects;
    bool inited = false;

    this() {
    }
    ~this() {
        if (inited) {
            destroy();
        }
    }

    void newObject(MNewObject msg) {
        objects ~= msg.object;
    }

    void objectDeleted(MObjectDeleted msg) {
        objects = objects.remove!(a => a == msg.object);
    }

    void setEngine(Engine e) {
        engine = e;
    }

    abstract void initialize() {
        if (inited) {
            return;
        }
        _M.register(this, &newObject);
        _M.register(this, &objectDeleted);
        inited = true;
    }
    void destroy() {
        if (!inited) {
            return;
        }
        _M.unregister(this);
        foreach_reverse(o; objects) {
            delete o;
        }
        objects = [];
        inited = false;
    }
}



