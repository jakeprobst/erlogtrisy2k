module erlogtrisy2k.optionmenu;



import erlogtrisy2k.scene;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.textrender;
import erlogtrisy2k.cursor;
import erlogtrisy2k.util;
import erlogtrisy2k.memory;

import erlogtrisy2k.titlescreen;
import erlogtrisy2k.maingame;

import std.stdio;
import std.conv;
import std.array;
import std.algorithm;



class OptionMenu : Scene {
    GameObject gradecursor;
    GameObject[] gradelevels;
    GameObject tetriscursor;
    GameObject[] tetrislevels;

    GameObject lazygravity, weightedrandom, startgame;
    GameObject optioncursor;

    bool opt_lazygravity = false;
    bool opt_weightedrandom = false;


    this () {
    }
    ~this() {
    }

    bool goBackToTitle(GameObject o) {
        engine.popScene();
        return true;
    }

    bool goBackToGradeSelect(GameObject o) {
        gradecursor.get!CInput().active = true;

        cursorVisible(tetriscursor, false);
        tetriscursor.get!CInput().active = false;
        return true;
    }

    bool goBackToTetrisSelect(GameObject o) {
        tetriscursor.get!CInput().active = true;

        cursorVisible(optioncursor, false);
        optioncursor.get!CInput().active = false;
        return true;
    }

    bool gradeLevelSelected(GameObject o) {
        gradecursor.get!CInput().active = false;

        cursorVisible(tetriscursor, true);
        cursorReset(tetriscursor);
        tetriscursor.get!CInput().active = true;

        return true;
    }

    bool tetrisLevelSelected(GameObject o) {
        tetriscursor.get!CInput().active = false;

        cursorVisible(optioncursor, true);
        cursorReset(optioncursor);
        optioncursor.get!CInput().active = true;

        return true;
    }

    bool selectOption(GameObject o) {
        CCursor cur = o.get!CCursor();
        if (cur.selected == lazygravity) {
            if (opt_lazygravity) {
                opt_lazygravity = false;
                renderText(lazygravity, "Lazy\nGravity", 32, Color(0,0,0));
            }
            else {
                opt_lazygravity = true;
                renderText(lazygravity, "Lazy\nGravity", 32, Color(255,0,0));
            }
        }
        if (cur.selected == weightedrandom) {
            if (opt_weightedrandom) {
                opt_weightedrandom = false;
                renderText(weightedrandom, "Weighted\nRandom", 32, Color(0,0,0));
            }
            else {
                opt_weightedrandom = true;
                renderText(weightedrandom, "Weighted\nRandom", 32, Color(255,0,0));
            }
        }
        if (cur.selected == startgame) {
            engine.pushScene(make!MainGame(gradelevels.countUntil(gradecursor.get!CCursor().selected),
                                          tetrislevels.countUntil(tetriscursor.get!CCursor().selected),
                                          opt_lazygravity, opt_weightedrandom));
        }
        return true;
    }

    override void start() {
        super.start();
        GameObject background = make!GameObject;
        CTexture tex = background.getAlways!CTexture();
        ubyte[800*500*4] blank;
        for(int i = 0; i < blank.length; i++) {
            blank[i] = 0xff;
        }
        tex.texture = _T.makeTexture(blank, 800, 500);
        tex.layer = Layer.Background;
        background.add(make!CPosition(0,0));

        GameObject gradelabel = make!GameObject;
        renderText(gradelabel, "Grade Level", 56, Color(0,0,0));
        gradelabel.getAlways!CPosition().x = 20;
        gradelabel.get!CPosition().y       = 20;

        foreach(n; 0..10) {
            GameObject lvl = make!GameObject;
            renderText(lvl, to!string(n+1), 42, Color(0,0,0));
            lvl.getAlways!CPosition().x = 50 + (75*(n%5));
            lvl.get!CPosition().y       = 90 + (60*(n/5));

            gradelevels ~= lvl;
        }

        GameObject tetrislabel = make!GameObject;
        renderText(tetrislabel, "Tetris Level", 56, Color(0,0,0));
        tetrislabel.getAlways!CPosition().x = 20;
        tetrislabel.get!CPosition().y       = 220;

        foreach(n; 0..10) {
            GameObject lvl = make!GameObject;
            renderText(lvl, to!string(n+1), 42, Color(0,0,0));
            lvl.getAlways!CPosition().x = 50 + (75*(n%5));
            lvl.get!CPosition().y       = 290 + (60*(n/5));

            tetrislevels ~= lvl;
        }

        lazygravity = make!GameObject;
        renderText(lazygravity, "Lazy\nGravity", 32, Color(0,0,0));
        lazygravity.getAlways!CPosition().x = 600;
        lazygravity.get!CPosition().y       = 20;

        weightedrandom = make!GameObject;
        renderText(weightedrandom, "Weighted\nRandom", 32, Color(0,0,0));
        weightedrandom.getAlways!CPosition().x = 600;
        weightedrandom.get!CPosition().y       = 150;

        startgame = make!GameObject;
        renderText(startgame, "Start Game", 32, Color(0,0,0));
        startgame.getAlways!CPosition().x = 620;
        startgame.get!CPosition().y       = 450;

        gradecursor = make!GameObject;
        CInput input = gradecursor.getAlways!CInput();
        input.action[InputType.KeyboardDown][Button.Escape] = &goBackToTitle;
        input.action[InputType.KeyboardDown][Button.Enter] = &gradeLevelSelected;
        makeCursor(gradecursor, gradelevels, 5, 2);

        tetriscursor = make!GameObject;
        input = tetriscursor.getAlways!CInput();
        input.action[InputType.KeyboardDown][Button.Escape] = &goBackToGradeSelect;
        input.action[InputType.KeyboardDown][Button.Enter] = &tetrisLevelSelected;
        input.active = false;
        makeCursor(tetriscursor, tetrislevels, 5, 2);
        cursorVisible(tetriscursor, false);

        optioncursor = make!GameObject;
        input = optioncursor.getAlways!CInput();
        input.action[InputType.KeyboardDown][Button.Escape] = &goBackToTetrisSelect;
        input.action[InputType.KeyboardDown][Button.Enter] = &selectOption;
        input.active = false;
        makeCursor(optioncursor, [lazygravity, weightedrandom, startgame], 1, 3);
        cursorVisible(optioncursor, false);
    }

    override void stop() {
        super.stop();

        gradelevels = [];
        tetrislevels = [];
    }
}
