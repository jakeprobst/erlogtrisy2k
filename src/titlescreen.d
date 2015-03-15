module erlogtrisy2k.mainmenu;

import erlogtrisy2k.scene;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.button;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.sprite;

import std.stdio;
import std.functional;


class MainMenu: Scene {
    GameObject background;

    this() {
    }

    ~this() {

    }


    override void initialize() {
        background = new GameObject;
        MakeSprite(background, "titlescreen.png", 0, 0);
        background.get!CTexture().layer = Layer.Background;
    }

    override void suspend() {
    }

    override void unsuspend() {
    }

    override void destroy() {
        delete background;
    }
}
