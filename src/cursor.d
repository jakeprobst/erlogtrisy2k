module erlogtrisy2k.cursor;

//import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;
import erlogtrisy2k.memory;

import std.stdio;
import std.functional;

const string TOPLEFT = "resources/misc/tl.png";
const string TOPRIGHT = "resources/misc/tr.png";
const string BOTTOMLEFT = "resources/misc/bl.png";
const string BOTTOMRIGHT = "resources/misc/br.png";


class CCursor : Component {
    GameObject topleft;
    GameObject topright;
    GameObject bottomleft;
    GameObject bottomright;

    GameObject selected;
    GameObject[] selections;
    int w, h;
    int xsel = 0, ysel = 0;
    int xoffset = 7, yoffset = 7;

    void delegate(GameObject) onChange = null;

    this() {
    }
    void destroy() {
        unmake(topleft);
        unmake(topright);
        unmake(bottomleft);
        unmake(bottomright);
    }
}

private void moveToItem(CCursor cur) {
    cur.selected = cur.selections[cur.ysel*cur.w + cur.xsel];

    CPosition selpos = cur.selected.get!CPosition();
    CTexture  seltex = cur.selected.get!CTexture();

    cur.topleft.get!CPosition().x = selpos.x - cur.xoffset;
    cur.topleft.get!CPosition().y = selpos.y - cur.yoffset;

    cur.topright.get!CPosition().x = selpos.x + seltex.texture.w + cur.xoffset - cur.bottomright.get!CTexture().texture.w;
    cur.topright.get!CPosition().y = selpos.y - cur.yoffset;

    cur.bottomleft.get!CPosition().x = selpos.x - cur.xoffset;
    cur.bottomleft.get!CPosition().y = selpos.y + seltex.texture.h + cur.yoffset - cur.bottomright.get!CTexture().texture.h;

    cur.bottomright.get!CPosition().x = selpos.x + seltex.texture.w + cur.xoffset - cur.bottomright.get!CTexture().texture.w;
    cur.bottomright.get!CPosition().y = selpos.y + seltex.texture.h + cur.yoffset - cur.bottomright.get!CTexture().texture.h;

    if (cur.onChange !is null) {
        cur.onChange(cur.selected);
    }
}

private bool moveCursorUp(GameObject cursor) {
    CCursor cur = cursor.get!CCursor();

    if (cur.ysel <= 0) {
        return false;
    }
    cur.ysel--;
    moveToItem(cur);

    return true;
}

private bool moveCursorDown(GameObject cursor) {
    CCursor cur = cursor.get!CCursor();

    if (cur.ysel >= cur.h-1) {
        return false;
    }
    cur.ysel++;
    moveToItem(cur);

    return true;
}

private bool moveCursorLeft(GameObject cursor) {
    CCursor cur = cursor.get!CCursor();

    if (cur.xsel <= 0) {
        return false;
    }
    cur.xsel--;
    moveToItem(cur);

    return true;
}

private bool moveCursorRight(GameObject cursor) {
    CCursor cur = cursor.get!CCursor();

    if (cur.xsel >= cur.w-1) {
        return false;
    }
    cur.xsel++;
    moveToItem(cur);

    return true;
}

void makeCursor(GameObject cursor, GameObject[] selections, int width, int height) {
    CCursor cur = cursor.getAlways!CCursor();

    cur.topleft = make!GameObject;
    cur.topleft.getAlways!CTexture().texture = _T.loadFile(TOPLEFT);
    cur.topleft.add(make!CPosition);

    cur.topright = make!GameObject;
    cur.topright.getAlways!CTexture().texture = _T.loadFile(TOPRIGHT);
    cur.topright.add(make!CPosition);

    cur.bottomleft = make!GameObject;
    cur.bottomleft.getAlways!CTexture().texture = _T.loadFile(BOTTOMLEFT);
    cur.bottomleft.add(make!CPosition);

    cur.bottomright = make!GameObject;
    cur.bottomright.getAlways!CTexture().texture = _T.loadFile(BOTTOMRIGHT);
    cur.bottomright.add(make!CPosition);

    cur.selections = selections;
    cur.selected = null;
    cur.w = width;
    cur.h = height;

    moveToItem(cur);

    CInput input = cursor.getAlways!CInput();
    input.action[InputType.KeyboardDown][Button.Up] = toDelegate(&moveCursorUp);
    input.action[InputType.KeyboardDown][Button.Down] = toDelegate(&moveCursorDown);
    input.action[InputType.KeyboardDown][Button.Left] = toDelegate(&moveCursorLeft);
    input.action[InputType.KeyboardDown][Button.Right] = toDelegate(&moveCursorRight);
}


void cursorVisible(GameObject cursor, bool vis) {
    CCursor cur = cursor.getAlways!CCursor();

    cur.topleft.get!CTexture().visible = vis;
    cur.topright.get!CTexture().visible = vis;
    cur.bottomleft.get!CTexture().visible = vis;
    cur.bottomright.get!CTexture().visible = vis;
}

void cursorReset(GameObject cursor) {
    CCursor cur = cursor.getAlways!CCursor();
    cur.xsel = 0;
    cur.ysel = 0;
    moveToItem(cur);
}



