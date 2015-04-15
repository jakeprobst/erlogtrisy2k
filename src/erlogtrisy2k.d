module erlogtrisy2k.erlogtrisy2k;


import erlogtrisy2k.engine;
import erlogtrisy2k.system;
import erlogtrisy2k.render;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.titlescreen;
import erlogtrisy2k.animation;
import erlogtrisy2k.memory;

import erlogtrisy2k.maingame;

class ErlogTrisY2K {
    Engine engine;
    this() {
        engine = make!Engine;
        engine.setRender(make!SRender("ErlogTris Y2K", 800, 500));
        engine.addSystem(make!SInput);
        engine.addSystem(make!SAnimation);

        //engine.pushScene(make!TitleScreen);
        engine.pushScene(make!MainGame(1, 1, false, false));
    }

    ~this() {
        unmake(engine);
    }

    void run() {
        engine.run();
    }
}
