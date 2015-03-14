module erlogtrisy2k.mainmenu;

import erlogtrisy2k.scene;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.button;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;

import std.stdio;
import std.functional;


bool moveToMouse(GameObject o, int x, int y) {
    CPosition pos = o.get!CPosition();
    pos.x = x;
    pos.y = y;

    return true;
}

bool moveUp(GameObject o) {
    CPosition pos = o.get!CPosition();
    pos.y -= 10;
    return false;
}
bool moveDown(GameObject o) {
    CPosition pos = o.get!CPosition();
    pos.y += 10;
    return false;
}
bool moveLeft(GameObject o) {
    CPosition pos = o.get!CPosition();
    pos.x -= 10;
    return false;
}
bool moveRight(GameObject o) {
    CPosition pos = o.get!CPosition();
    pos.x += 10;
    return false;
}

class MainMenu: Scene {
    GameObject bg;
    GameObject bg2;

    this() {
    }

    ~this() {

    }

    override void initialize() {
        engine.addSystem(new SButton);

        bg = new GameObject;
        bg.add(new CPosition(10,10));
        bg.add(new CTexture());
        _T.loadFile(bg, "resources/images/red.png");
        CInput input = new CInput();
        input.mouse = toDelegate(&moveToMouse);
        bg.add(input);

        bg2 = new GameObject;
        bg2.add(new CPosition(20,25));
        bg2.add(new CTexture());
        _T.loadFile(bg2, "resources/images/green.png");
        input = new CInput();
        input.action[InputType.KeyboardDown][Button.Up] = toDelegate(&moveUp);
        input.action[InputType.KeyboardDown][Button.Down] = toDelegate(&moveDown);
        input.action[InputType.KeyboardDown][Button.Left] = toDelegate(&moveLeft);
        input.action[InputType.KeyboardDown][Button.Right] = toDelegate(&moveRight);
        bg2.add(input);
    }

    override void suspend() {
    }

    override void unsuspend() {
    }

    override void destroy() {
        delete bg;
        delete bg2;

        SButton b = engine.removeSystem!SButton();
        delete b;
    }
}
