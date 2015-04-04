module erlogtrisy2k.block;

import erlogtrisy2k.gameobject;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.fallingpiece;

import std.traits;

enum PieceType {
    I,
    L,
    J,
    S,
    Z,
    O,
    T
}

class CBlock: Component {
    wchar kanji;
    int x, y;
}

enum string[PieceType] piecetotex = [
    PieceType.I : "resources/images/maingame/gray.png",
    PieceType.L : "resources/images/maingame/blue.png",
    PieceType.J : "resources/images/maingame/red.png",
    PieceType.S : "resources/images/maingame/yellow.png",
    PieceType.Z : "resources/images/maingame/cyan.png",
    PieceType.O : "resources/images/maingame/purple.png",
    PieceType.T : "resources/images/maingame/green.png",
];

Texture[PieceType] texlookup;

static ~this() {
    foreach(type, tex; texlookup) {
        delete tex;
    }
}

void loadTexture(PieceType type) {
    texlookup[type] = _T.loadFile(piecetotex[type]);
}


Texture getBlockTexture(PieceType type) {
    if (!(type in texlookup)) {
        loadTexture(type);
    }
    return texlookup[type];
}

void makeBlock(GameObject block, PieceType type, int x, int y)
{
    CBlock b = block.getAlways!CBlock();
    b.x = x;
    b.y = y;

    CTexture tex = block.getAlways!CTexture();
    tex.texture = new Texture(getBlockTexture(type));
    tex.layer = Layer.Block;

    CPosition pos = block.getAlways!CPosition();


}
