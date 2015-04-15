module erlogtrisy2k.nextpiece;




import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.block;
import erlogtrisy2k.pieceoffsets;
import erlogtrisy2k.texture;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.fallingpiece;
import erlogtrisy2k.memory;

import std.stdio;
import std.format;
import std.random;

//const int NEXTBLOCKX = 20;
//const int NEXTBLOCKY = 36;
//const int NEXTBLOCKX = 20+((181-20)/2);
//const int NEXTBLOCKY = 36+((155-36)/2);
const int NEXTBLOCKX = (181)/2;
const int NEXTBLOCKY = (155)/2;


class CNextPiece: Component {
    PieceType type;
    GameObject[4] blocks;
}

class MNeedNextPiece : Message {
}


class NextPiece {
    GameObject nextpiece;

    this() {
        _M.register(this, &needNextPiece);
        nextpiece = make!GameObject;
        makeNextPiece(nextpiece);
        setPieceType(nextpiece);
    }
    ~this() {
        _M.unregister(this);
    }

    void needNextPiece(MNeedNextPiece msg) {
        _M.send(make!MNextPiece(nextpiece.get!CNextPiece().type));
        setPieceType(nextpiece);
    }
}



void makeNextPiece(GameObject o) {
    CNextPiece nextpiece = o.getAlways!CNextPiece();

    foreach(i; 0..4) {
        nextpiece.blocks[i] = make!GameObject;
    }
}

void setPieceType(GameObject o) {
    CNextPiece nextpiece = o.getAlways!CNextPiece();
    nextpiece.type = uniform!PieceType();

    PieceOffset offset = getOffset(nextpiece.type)[0];

    foreach(i; 0..4) {
        CTexture tex = nextpiece.blocks[i].getAlways!CTexture();
        tex.texture = make!Texture(getBlockTexture(nextpiece.type));
        tex.layer = Layer.Block;

        CPosition pos = nextpiece.blocks[i].getAlways!CPosition();
        pos.x = NEXTBLOCKX + offset.offset[i].x * tex.texture.w;
        pos.y = NEXTBLOCKX + offset.offset[i].y * tex.texture.h;
    }
}


