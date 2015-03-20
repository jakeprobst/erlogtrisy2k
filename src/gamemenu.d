module erlogtrisy2k.gamemenu;



import erlogtrisy2k.scene;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.input;

import erlogtrisy2k.titlescreen;

import std.stdio;



class GameMenu : Scene {
    GameObject cursor;
    //GameObject[] jlptlevels;
    //GameObject[] tetrislevels;



    this () {
    }
    ~this() {
    }



    bool goBackToTitle(GameObject o) {
        engine.popScene();
        return true;
    }

    override void initialize() {
        cursor = new GameObject;
        CInput i = cursor.getAlways!CInput();

        i.action[InputType.KeyboardDown][Button.Escape] = &goBackToTitle;
    }
    override void suspend() {
        destroy();
    }
    override void unsuspend() {
        initialize();
    }
    override void destroy() {
        delete cursor;
    }

}
