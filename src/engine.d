module erlogtrisy2k.engine;

import erlogtrisy2k.messagebus;
import erlogtrisy2k.system;
import erlogtrisy2k.scene;
import erlogtrisy2k.memory;

import std.stdio;
import core.time;
import std.container;
import std.datetime;
import std.array;
import std.algorithm;

//const float FPS = 60;
//const float DT = (1/FPS);

// 60 fps frame delta in nanoseconds
const int DT = 16666666;




class Engine {
    bool running = true;
    System render;
    System[] systems;
    Scene[] scenes;

    Scene pushscene = null;
    bool popscene = false;

    this() {
        _M.register(this, &quit);
    }

    ~this() {
        foreach(s; scenes) {
            unmake(s);
        }
        foreach(s; systems) {
            unmake(s);
        }
    }

    void setRender(System s) {
        s.start();
        render = s;
    }

    void addSystem(System s) {
        s.start();
        systems ~= s;
    }

    void removeSystem(T)() {
        foreach(s; systems) {
            auto a = cast(T)s;
            if (a !is null) {
                systems = remove!(a => a == s)(systems);
            }
            unmake(a);
        }
        //return null;
    }

    T get(T)() {
        foreach(s; systems ~ render) {
            auto a = cast(T)s;
            if (a !is null) {
                return a;
            }

        }
        return null;
    }

    void update(int frame) {
        foreach(s; systems) {
            s.update(frame);
        }
    }

    void pushScene(Scene s) {
        pushscene = s;
    }

    void popScene() {
        popscene = true;
    }

    void checkSceneChange() {
        if (pushscene) {
            if (scenes.length > 0) {
                scenes[$-1].stop();
            }
            pushscene.setEngine(this);
            pushscene.start();

            scenes ~= pushscene;
            pushscene = null;
        }

        if (popscene) {
            Scene s = scenes.back();
            s.stop();
            unmake(s);
            scenes.popBack();
            if (scenes.length > 0) {
                scenes[$-1].start();
            }
            popscene = false;
        }
    }

    void run() {
        float accumulator = 0;
        auto framestart = Clock.currAppTick();
        int frame;

        while (running) {
            const auto curtime = Clock.currAppTick();

            accumulator += ((curtime - framestart)).nsecs();
            framestart = curtime;

            while (accumulator > DT) {
                frame++;
                update(frame);
                accumulator -= DT;

                checkSceneChange();
            }
            render.update(frame);
        }
    }

    void quit(MQuitProgram m = null) {
        running = false;
    }

}
