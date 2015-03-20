module erlogtrisy2k.erlogtrisy2k;


import erlogtrisy2k.engine;
import erlogtrisy2k.system;
import erlogtrisy2k.render;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.titlescreen;
import erlogtrisy2k.animation;

class ErlogTrisY2K {
    Engine engine;
    this() {
        engine = new Engine;
        engine.setRender(new SRender("ErlogTris Y2K", 800, 500));
        engine.addSystem(new SInput);
        engine.addSystem(new SAnimation);

        engine.pushScene(new TitleScreen);
    }

    ~this() {
        delete engine;
    }

    void run() {
        engine.run();
    }
}
