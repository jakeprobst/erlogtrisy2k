module erlogtrisy2k.cursor;

//import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.texture;
import erlogtrisy2k.input;

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

    GameObject[] selections;
    int w, h;
    int xsel = 0, ysel = 0;
    int xoffset = 7, yoffset = 7;

    this() {
    }
    ~this() {
        delete topleft;
        delete topright;
        delete bottomleft;
        delete bottomright;
    }

}

private void moveToItem(CCursor cur) {
    GameObject selected = cur.selections[cur.ysel*cur.w + cur.xsel];

    CPosition selpos = selected.get!CPosition();
    CTexture  seltex = selected.get!CTexture();

    cur.topleft.get!CPosition().x = selpos.x - cur.xoffset;
    cur.topleft.get!CPosition().y = selpos.y - cur.yoffset;

    cur.topright.get!CPosition().x = selpos.x + seltex.texture.w + cur.xoffset - cur.bottomright.get!CTexture().texture.w;
    cur.topright.get!CPosition().y = selpos.y - cur.yoffset;

    cur.bottomleft.get!CPosition().x = selpos.x - cur.xoffset;
    cur.bottomleft.get!CPosition().y = selpos.y + seltex.texture.h + cur.yoffset - cur.bottomright.get!CTexture().texture.h;

    cur.bottomright.get!CPosition().x = selpos.x + seltex.texture.w + cur.xoffset - cur.bottomright.get!CTexture().texture.w;
    cur.bottomright.get!CPosition().y = selpos.y + seltex.texture.h + cur.yoffset - cur.bottomright.get!CTexture().texture.h;

    //writefln("(%d, %d)", cur.topleft.get!CPosition().x, cur.topleft.get!CPosition().y);
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

    cur.topleft = new GameObject;
    cur.topleft.getAlways!CTexture().texture = _T.loadFile(TOPLEFT);
    cur.topleft.add(new CPosition);

    cur.topright = new GameObject;
    cur.topright.getAlways!CTexture().texture = _T.loadFile(TOPRIGHT);
    cur.topright.add(new CPosition);

    cur.bottomleft = new GameObject;
    cur.bottomleft.getAlways!CTexture().texture = _T.loadFile(BOTTOMLEFT);
    cur.bottomleft.add(new CPosition);

    cur.bottomright = new GameObject;
    cur.bottomright.getAlways!CTexture().texture = _T.loadFile(BOTTOMRIGHT);
    cur.bottomright.add(new CPosition);

    cur.selections = selections;
    cur.w = width;
    cur.h = height;

    moveToItem(cur);

    CInput input = cursor.getAlways!CInput();
    input.action[InputType.KeyboardDown][Button.Up] = toDelegate(&moveCursorUp);
    input.action[InputType.KeyboardDown][Button.Down] = toDelegate(&moveCursorDown);
    input.action[InputType.KeyboardDown][Button.Left] = toDelegate(&moveCursorLeft);
    input.action[InputType.KeyboardDown][Button.Right] = toDelegate(&moveCursorRight);
}







