module erlogtrisy2k.button;

import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;

import std.functional;


class CButton: Component {
    Texture normal;
    Texture mouseover;
    Texture clicked;
    void delegate() callback;
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
    btn.normal = _T.loadFile(normal);
    btn.mouseover = _T.loadFile(mouseover);
    btn.clicked = _T.loadFile(clicked);
    btn.callback = cb;

    CInput input = o.getAlways!CInput();
    input.mouse = toDelegate(&buttonMouseOver);
    input.action[InputType.MouseDown][Button.MouseLeft] = toDelegate(&buttonMouseDown);
    input.action[InputType.MouseUp][Button.MouseLeft] = toDelegate(&buttonMouseUp);

    CTexture tex = o.getAlways!CTexture();
    tex.texture = btn.normal;
}


















