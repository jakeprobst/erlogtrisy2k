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
        //engine.addSystem(new SRender("ErlogTris Y2K", 1280, 720));
        engine.setRender(new SRender("ErlogTris Y2K", 1280, 720));
        //engine.addSystem(new STexture(engine.get!SRender));
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
