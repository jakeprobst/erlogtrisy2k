module erlogtrisy2k.titlescreen;

import erlogtrisy2k.scene;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.button;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.sprite;
import erlogtrisy2k.animation;
import erlogtrisy2k.gamemenu;
import erlogtrisy2k.util;

import std.stdio;
import std.functional;


class TitleScreen: Scene {
    GameObject background;
    GameObject startbutton;

    this() {
    }

    ~this() {
    }

    void startGame() {
        engine.pushScene(new GameMenu());
    }

    override void initialize() {
        background = new GameObject;
        MakeSprite(background, "titlescreen/titlescreen.png", 0, 0);
        background.get!CTexture().layer = Layer.Background;

        startbutton = new GameObject;
        MakeAnimatedButton(startbutton, ["titlescreen/start_n1.png"],
                                         "titlescreen/start_m%d.png".expandString(1, 5),
                                        ["titlescreen/start_c1.png"],
                                        200, 250, &startGame);
        startbutton.get!CAnimation().changerate = 5;
        startbutton.get!CAnimation().loop = false;
    }

    override void suspend() {
        destroy();
    }

    override void unsuspend() {
        initialize();
    }

    override void destroy() {
        delete background;
        delete startbutton;
    }
}
