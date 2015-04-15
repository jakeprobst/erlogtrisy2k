module erlogtrisy2k.scene;

import erlogtrisy2k.engine;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.memory;

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
            stop();
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

    abstract void start() {
        if (inited) {
            return;
        }
        _M.register(this, &newObject);
        _M.register(this, &objectDeleted);
        inited = true;
    }
    void stop() {
        if (!inited) {
            return;
        }
        _M.unregister(this);
        foreach_reverse(o; objects) {
            unmake(o);
        }
        objects = [];
        inited = false;
    }
}



