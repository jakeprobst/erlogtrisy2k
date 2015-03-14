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
    GameObject btn;

    this() {
    }

    ~this() {

    }

    void printSomething() {
       writeln("oh shit look at me I`m a callback");
    }

    override void initialize() {
        //engine.addSystem(new SButton);

        bg = new GameObject;
        bg.add(new CPosition(10,10));

        CTexture tex = new CTexture();
        tex.texture = _T.loadFile("resources/images/red.png");
        bg.add(tex);

        CInput input = new CInput();
        input.mouse = toDelegate(&moveToMouse);
        bg.add(input);

        bg2 = new GameObject;
        bg2.add(new CPosition(20,25));

        tex = new CTexture();
        tex.texture = _T.loadFile("resources/images/red.png");
        bg2.add(tex);

        input = new CInput();
        input.action[InputType.KeyboardDown][Button.Up] = toDelegate(&moveUp);
        input.action[InputType.KeyboardDown][Button.Down] = toDelegate(&moveDown);
        input.action[InputType.KeyboardDown][Button.Left] = toDelegate(&moveLeft);
        input.action[InputType.KeyboardDown][Button.Right] = toDelegate(&moveRight);
        bg2.add(input);

        btn = MakeButton("resources/images/blue.png",
                         "resources/images/purple.png",
                         "resources/images/yellow.png",
                         100, 300, &printSomething);
    }

    override void suspend() {
    }

    override void unsuspend() {
    }

    override void destroy() {
        delete bg;
        delete bg2;
        delete btn;

        /*SButton b = engine.removeSystem!SButton();
        delete b;*/
    }
}
