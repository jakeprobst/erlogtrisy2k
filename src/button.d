module erlogtrisy2k.button;

import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.animation;
import erlogtrisy2k.memory;

import std.stdio;
import std.functional;


class CButton: Component {
    Texture normal;
    Texture mouseover;
    Texture clicked;
    void delegate() callback;

    ~this() {
        unmake(normal);
        unmake(mouseover);
        unmake(clicked);
    }
}

class CAnimatedButton: Component {
    Texture[] normal;
    Texture[] mouseover;
    Texture[] clicked;
    void delegate() callback;

    ~this() {
        foreach(n; normal){
            unmake(n);
        }
        foreach(m; mouseover){
            unmake(m);
        }
        foreach(c; clicked){
            unmake(c);
        }
    }
}

bool buttonMouseOver(GameObject o, int x, int y) {
    CPosition pos = o.get!CPosition();
    CButton btn = o.get!CButton();
    CTexture tex = o.get!CTexture();
    if (x > pos.x && x < pos.x + tex.texture.w) {
        if (y > pos.y && y < pos.y + tex.texture.h) {
            if (tex.texture == btn.normal) {
                tex.texture = btn.mouseover;
            }
            return false;
        }
    }

    if (tex.texture != btn.normal) {
        tex.texture = btn.normal;
    }

    return false;
}


bool buttonMouseDown(GameObject o)
{
    CButton btn = o.get!CButton();
    CTexture tex = o.get!CTexture();

    if (tex.texture == btn.mouseover) {
        tex.texture = btn.clicked;
    }

    return false;
}

bool buttonMouseUp(GameObject o)
{
    CButton btn = o.get!CButton();
    CTexture tex = o.get!CTexture();

    if (tex.texture == btn.clicked) {
        btn.callback();
        tex.texture = btn.mouseover;
    }

    return false;
}


void MakeButton(GameObject o, string normal, string mouseover, string clicked, int x, int y, void delegate() cb) {
    CPosition pos = o.getAlways!CPosition();
    pos.x = x;
    pos.y = y;

    CButton btn = o.getAlways!CButton();
    btn.normal = _T.loadFile("resources/images/" ~ normal);
    btn.mouseover = _T.loadFile("resources/images/" ~ mouseover);
    btn.clicked = _T.loadFile("resources/images/" ~ clicked);
    btn.callback = cb;

    CInput input = o.getAlways!CInput();
    input.mouse = toDelegate(&buttonMouseOver);
    input.action[InputType.MouseDown][Button.MouseLeft] = toDelegate(&buttonMouseDown);
    input.action[InputType.MouseUp][Button.MouseLeft] = toDelegate(&buttonMouseUp);

    CTexture tex = o.getAlways!CTexture();
    tex.texture = btn.normal;
}



bool animatedButtonMouseOver(GameObject o, int x, int y) {
    CPosition pos = o.get!CPosition();
    CAnimatedButton btn = o.get!CAnimatedButton();
    CAnimation anim = o.get!CAnimation();
    if (x > pos.x && x < pos.x + anim.textures[anim.index].w) {
        if (y > pos.y && y < pos.y + anim.textures[anim.index].h) {
            if (anim.textures == btn.normal) {
                anim.textures = btn.mouseover;
                anim.index = 0;
                anim.loop = false;
            }
            return false;
        }
    }

    if (anim.textures != btn.normal) {
        anim.textures = btn.normal;
        anim.index = 0;
        anim.loop = true;
    }

    return false;
}


bool animatedButtonMouseDown(GameObject o)
{
    CAnimatedButton btn = o.get!CAnimatedButton();
    CAnimation anim = o.get!CAnimation();

    if (anim.textures == btn.mouseover) {
        anim.textures = btn.clicked;
        anim.index = 0;
        anim.loop = true;
    }

    return false;
}

bool animatedButtonMouseUp(GameObject o)
{
    CAnimatedButton btn = o.get!CAnimatedButton();
    CAnimation anim = o.get!CAnimation();

    if (anim.textures == btn.clicked) {
        btn.callback();
        anim.textures = btn.mouseover;
        anim.index = 0;
        anim.loop = true;
    }

    return false;
}


void MakeAnimatedButton(GameObject o, string[] normal, string[] mouseover, string[] clicked, int x, int y, void delegate() cb)
{
    CPosition pos = o.getAlways!CPosition();
    pos.x = x;
    pos.y = y;

    CAnimatedButton btn = o.getAlways!CAnimatedButton();
    foreach(n; normal) {
        btn.normal ~= _T.loadFile("resources/images/" ~ n);
    }
    foreach(m; mouseover) {
        btn.mouseover ~= _T.loadFile("resources/images/" ~ m);
    }
    foreach(c; clicked) {
        btn.clicked ~= _T.loadFile("resources/images/" ~ c);
    }
    btn.callback = cb;

    CInput input = o.getAlways!CInput();
    input.mouse = toDelegate(&animatedButtonMouseOver);
    input.action[InputType.MouseDown][Button.MouseLeft] = toDelegate(&animatedButtonMouseDown);
    input.action[InputType.MouseUp][Button.MouseLeft] = toDelegate(&animatedButtonMouseUp);

    CAnimation anim = o.getAlways!CAnimation();
    anim.textures = btn.normal;
    anim.changerate = 10;

    o.add(make!CTexture);
}















