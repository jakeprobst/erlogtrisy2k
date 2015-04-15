module erlogtrisy2k.system;

import erlogtrisy2k.engine;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.messagebus;

import std.stdio;
import std.algorithm;


// TODO: for systems that have no requirements (ones that want specific things)
// all objects in the game get added to the objects list.
// they don't get iterated over so its not that bad, but it makes removal slow
// so maybe make addObject return a bool and only add to objects if it returns
// true?

class System {
    string[] requires;
    GameObject[] objects;

    this() {
        _M.register(this, &componentChange);
        _M.register(this, &deleteObject);
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
            foreach(o; objects) {
                if (o == m.object) {
                    return;
                }
            }
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


    abstract void start();
    abstract void addObject(GameObject);
    abstract void removeObject(GameObject);
    abstract void update(int);
}
