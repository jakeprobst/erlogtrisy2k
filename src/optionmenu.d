module erlogtrisy2k.optionmenu;



import erlogtrisy2k.scene;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.textrender;
import erlogtrisy2k.cursor;
import erlogtrisy2k.util;

import erlogtrisy2k.titlescreen;

import std.stdio;
import std.conv;



class OptionMenu : Scene {
    GameObject background;
    GameObject cursor;
    GameObject gradelabel;
    GameObject[] gradelevels;
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
        background = new GameObject;
        CTexture tex = background.getAlways!CTexture();
        ubyte[800*500*4] blank;
        for(int i = 0; i < blank.length; i++) {
            blank[i] = 0xff;
        }
        tex.texture = _T.makeTexture(blank, 800, 500);
        tex.layer = Layer.Default;
        background.add(new CPosition(0,0));

        gradelabel = new GameObject;
        renderText(gradelabel, "Grade Level", 56, Color(0,0,0));
        gradelabel.getAlways!CPosition().x = 20;
        gradelabel.get!CPosition().y       = 20;

        foreach(n; 0..10) {
            GameObject lvl = new GameObject;
            renderText(lvl, to!string(n+1), 42, Color(0,0,0));
            lvl.getAlways!CPosition().x = 50 + (75*(n%5));
            lvl.get!CPosition().y       = 90 + (60*(n/5));

            gradelevels ~= lvl;
        }

        cursor = new GameObject;
        CInput i = cursor.getAlways!CInput();
        i.action[InputType.KeyboardDown][Button.Escape] = &goBackToTitle;
        makeCursor(cursor, gradelevels, 5, 2);



    }
    override void suspend() {
        destroy();
    }
    override void unsuspend() {
        initialize();
    }
    override void destroy() {
        foreach(o; gradelevels) {
            delete o;
        }
        delete gradelabel;
        delete cursor;
        delete background;
    }

}
