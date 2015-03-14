module erlogtrisy2k.erlogtrisy2k;


import erlogtrisy2k.engine;
import erlogtrisy2k.system;
import erlogtrisy2k.render;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.mainmenu;

class ErlogTrisY2K {
    Engine engine;
    this() {
        engine = new Engine;
        //engine.addSystem(new SRender("ErlogTris Y2K", 1280, 720));
        engine.setRender(new SRender("ErlogTris Y2K", 1280, 720));
        //engine.addSystem(new STexture(engine.get!SRender));
        engine.addSystem(new SInput);


        engine.pushScene(new MainMenu);
    }

    ~this() {
        delete engine;
    }

    void run() {
        engine.run();
    }
}
