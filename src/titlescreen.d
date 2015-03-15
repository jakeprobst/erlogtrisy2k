module erlogtrisy2k.titlescreen;

import erlogtrisy2k.scene;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.button;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.sprite;
import erlogtrisy2k.animation;

import std.stdio;
import std.functional;


class TitleScreen: Scene {
    GameObject background;
    GameObject an;
    GameObject asdf;

    this() {
    }

    ~this() {

    }

    void oshtson() {
        writeln("oshtson");
    }



    override void initialize() {
        background = new GameObject;
        MakeSprite(background, "titlescreen/titlescreen.png", 0, 0);
        background.get!CTexture().layer = Layer.Background;


        an = new GameObject;
        MakeAnimation(an, ["red.png", "blue.png", "yellow.png", "cyan.png", "purple.png", "red.png"]);
        CPosition pos = an.getAlways!CPosition();
        pos.x = 300;
        pos.y = 300;


        asdf = new GameObject;
        MakeAnimatedButton(asdf, ["red.png", "blue.png", "yellow.png"], ["cyan.png", "purple.png", "red.png"], ["gray.png", "cyan.png", "purple.png"] , 100, 100, &oshtson);
    }

    override void suspend() {
    }

    override void unsuspend() {
    }

    override void destroy() {
        delete background;
        delete an;
        delete asdf;
    }
}
