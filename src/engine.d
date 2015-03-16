module erlogtrisy2k.engine;

import erlogtrisy2k.messagebus;
import erlogtrisy2k.system;
import erlogtrisy2k.scene;

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
        _M.register(this, MsgType.QuitProgram, &quit);
    }

    ~this() {
        foreach(s; scenes) {
            s.destroy();
            delete s;
        }
        foreach(s; systems) {
            delete s;
        }
    }

    void setRender(System s) {
        s.initialize();
        render = s;
    }

    void addSystem(System s) {
        s.initialize();
        systems ~= s;
    }

    T removeSystem(T)() {
        foreach(s; systems) {
            auto a = cast(T)s;
            if (a !is null) {
                systems = remove!(a => a == s)(systems);
            }
            return a;
        }
        return null;
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
                scenes[$-1].suspend();
            }
            pushscene.setEngine(this);
            pushscene.initialize();
            scenes ~= pushscene;
            pushscene = null;
        }

        if (popscene) {
            Scene s = scenes.back();
            s.destroy();
            delete s;
            scenes.popBack();
            if (scenes.length > 0) {
                scenes[$-1].unsuspend();
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
