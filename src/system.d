module erlogtrisy2k.system;

import erlogtrisy2k.engine;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.messagebus;

import std.stdio;
import std.algorithm;


class System {
    CType[] requires;
    GameObject[] objects;

    this() {
        _M.register(this, MsgType.ComponentChange, &componentChange);
        _M.register(this, MsgType.ObjectDeleted, &deleteObject);

    }
    ~this() {}

    void componentChange(MComponentChange m) {
        bool add = true;
        foreach(r; requires) {
            if (!m.object.has(r)) {
                add = false;
                break;
            }
        }

        if (add) {
            objects ~= m.object;
            addObject(m.object);
        }
        else {
            objects = remove!(a => a == m.object)(objects);
            removeObject(m.object);
        }
    }

    void deleteObject(MObjectDeleted m) {
        if (objects.find(m.object)) {
            objects = remove!(a => a == m.object)(objects);
            removeObject(m.object);
        }
    }


    abstract void initialize();
    abstract void addObject(GameObject);
    abstract void removeObject(GameObject);
    abstract void update(int);
}
