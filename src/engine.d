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

    void update() {
        foreach(s; systems) {
            s.update();
        }
    }

    void pushScene(Scene s) {
        if (scenes.length > 0) {
            scenes[$-1].suspend();
        }
        s.setEngine(this);
        s.initialize();
        scenes ~= s;
    }

    void popScene() {
        Scene s = scenes.back();
        s.destroy();
        delete s;
        scenes.popBack();
        if (scenes.length > 0) {
            scenes[$-1].unsuspend();
        }
    }

    void run() {
        float accumulator = 0;
        auto framestart = Clock.currAppTick();
        int a;

        while (running) {
            const auto curtime = Clock.currAppTick();

            accumulator += ((curtime - framestart)).nsecs();
            framestart = curtime;

            while (accumulator > DT) {
                a++;
                update();
                accumulator -= DT;
            }
            render.update();
        }
    }

    void quit(MQuitProgram m = null) {
        running = false;
    }

}
