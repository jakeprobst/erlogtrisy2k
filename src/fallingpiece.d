module erlogtrisy2k.fallingpiece;


import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.grid;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.block;
import erlogtrisy2k.pieceoffsets;
import erlogtrisy2k.nextpiece;
import erlogtrisy2k.input;
import erlogtrisy2k.memory;

import std.stdio;
import std.random;
import std.algorithm;
import std.array;
import std.functional;


class CFallingPiece: Component {
    PieceType type;
    int speed= 60; // number of frames before dropping
    int lastdrop;
    int x, y;
    int rotation = 0;
    PieceOffset[] offset;
    GameObject[] blocks;
}

class MNextPiece: Message {
    PieceType type;
    this(PieceType t) {
        type = t;
    }
}


class SFallingPiece: System {
    GameObject grid = null;
    GameObject fallingpiece = null;

    this() {
        _M.register(this, &nextPiece);
    }
    ~this() {
        _M.unregister(this);
    }

    override void start() {
    }
    override void addObject(GameObject o) {
        if (o.has!CFallingPiece()) {
            fallingpiece = o;
        }
        else if (o.has!CGrid()) {
            grid = o;
        }
    }
    override void removeObject(GameObject o) {
        if (o == fallingpiece) {
            fallingpiece = null;
        }
        else if (o == grid) {
            grid = null;
        }
    }

    void nextPiece(MNextPiece msg) {
        fallingpiece = make!GameObject;
        makeFallingPiece(fallingpiece, msg.type, grid.get!CGrid());
        setBlockPosition(fallingpiece);
    }

    override void update(int frame) {
        if (grid is null) {
            return;
        }
        if (fallingpiece is null) {
            _M.send(make!MNeedNextPiece);
        }

        CFallingPiece fpiece = fallingpiece.get!CFallingPiece();
        if (frame > (fpiece.speed + fpiece.lastdrop)) {
            bool movedown = true;
            CGrid g = grid.get!CGrid();
            foreach(block; fpiece.blocks) {
                CBlock b = block.get!CBlock();

                if (b.x < 0 || b.y < 0) {
                    continue;
                }

                if (b.y + 1 > GRIDHEIGHT-1) {
                    movedown = false;
                    break;

                }
                if ((g.blocks[b.x][b.y+1] !is null) && !(fpiece.blocks.count(g.blocks[b.x][b.y+1]))) {
                    movedown = false;
                    break;
                }
            }

            if (movedown) {
                fpiece.y++;
                setBlockPosition(fallingpiece);
                fpiece.lastdrop = frame;
            }
            else {
                unmake(fallingpiece);
                fallingpiece = null;
            }
        }
    }
}

bool verifyOpen(CFallingPiece fpiece, CBlock block, CGrid grid, int xoff, int yoff) {
    if (!(0 <= block.x+xoff && block.x+xoff <= GRIDWIDTH-1)) {
        return false;
    }
    if (!(0 <= block.y+yoff && block.y+yoff <= GRIDHEIGHT-1)) {
        return false;
    }

    if (!(fpiece.blocks.canFind(grid.blocks[block.x+xoff][block.y+yoff]))
            && (grid.blocks[block.x+xoff][block.y+yoff] !is null)) {
        return false;
    }

    return true;
}

bool movePieceLeft(GameObject o, CGrid grid) {
    CFallingPiece fpiece = o.get!CFallingPiece();

    foreach(block; fpiece.blocks) {
        CBlock b = block.get!CBlock();
        if (!verifyOpen(fpiece, b, grid, -1, 0)) {
            return true;
        }
    }

    fpiece.x--;
    setBlockPosition(o);
    return true;
}

bool movePieceRight(GameObject o, CGrid grid) {
    CFallingPiece fpiece = o.get!CFallingPiece();

    foreach(block; fpiece.blocks) {
        CBlock b = block.get!CBlock();
        if (!verifyOpen(fpiece, b, grid, 1, 0)) {
            return true;
        }
    }

    fpiece.x++;
    setBlockPosition(o);
    return true;
}

bool movePieceDown(GameObject o, CGrid grid) {
    CFallingPiece fpiece = o.get!CFallingPiece();

    foreach(block; fpiece.blocks) {
        CBlock b = block.get!CBlock();
        if (!verifyOpen(fpiece, b, grid, 0, 1)) {
            return true;
        }
    }

    fpiece.y++;
    setBlockPosition(o);
    return true;
}

bool rotatePieceCW(GameObject o, CGrid grid) {
    CFallingPiece fpiece = o.get!CFallingPiece();
    int nextrotation = (fpiece.rotation + 1) % cast(int)fpiece.offset.length;
    foreach(int i, block; fpiece.blocks) {
        CBlock b = block.get!CBlock();
        int xoff = fpiece.offset[nextrotation][i].x - fpiece.offset[fpiece.rotation][i].x;
        int yoff = fpiece.offset[nextrotation][i].y - fpiece.offset[fpiece.rotation][i].y;

        if (!verifyOpen(fpiece, b, grid, xoff, yoff)) {
            return true;
        }
    }

    foreach(int i, block; fpiece.blocks) {
        CBlock b = block.get!CBlock();
        b.x = fpiece.offset[nextrotation][i].x;
        b.y = fpiece.offset[nextrotation][i].y;
    }

    fpiece.rotation = nextrotation;
    setBlockPosition(o);
    return true;
}

bool rotatePieceCCW(GameObject o, CGrid grid) {
    CFallingPiece fpiece = o.get!CFallingPiece();
    int nextrotation = fpiece.rotation - 1;
    if (nextrotation <= 0) {
        nextrotation = cast(int)fpiece.offset.length;
    }
    foreach(int i, block; fpiece.blocks) {
        CBlock b = block.get!CBlock();
        int xoff = fpiece.offset[nextrotation][i].x - fpiece.offset[fpiece.rotation][i].x;
        int yoff = fpiece.offset[nextrotation][i].y - fpiece.offset[fpiece.rotation][i].y;

        if (!verifyOpen(fpiece, b, grid, xoff, yoff)) {
            return true;
        }
    }

    foreach(int i, block; fpiece.blocks) {
        CBlock b = block.get!CBlock();
        b.x = fpiece.offset[nextrotation][i].x;
        b.y = fpiece.offset[nextrotation][i].y;
    }

    fpiece.rotation = nextrotation;
    setBlockPosition(o);
    return true;
}

bool dropPiece(GameObject o, CGrid grid) {
    CFallingPiece fpiece = o.get!CFallingPiece();

    int i;
    outer: for(i = 0; i < GRIDHEIGHT; i++){
        foreach(block; fpiece.blocks) {
            CBlock b = block.get!CBlock();
            if (!verifyOpen(fpiece, b, grid, 0, i)) {
                break outer;
            }
        }
    }
    fpiece.y += i-1;
    fpiece.lastdrop = 0;
    setBlockPosition(o);
    return true;

}

void makeFallingPiece(GameObject o, PieceType type, CGrid grid) {
    CFallingPiece fpiece = o.getAlways!CFallingPiece();

    fpiece.type = type;
    fpiece.offset = getOffset(fpiece.type);
    fpiece.x = 6;
    fpiece.y = 0;

    fpiece.blocks.length = 4;
    foreach(i; 0..4) {
        fpiece.blocks[i] = make!GameObject;
        makeBlock(fpiece.blocks[i], type, fpiece.offset[0][i].x, fpiece.offset[0][i].y);
    }

    CInput input = o.getAlways!CInput();
    input.action[InputType.KeyboardDown][Button.Left] = delegate bool(GameObject o) => movePieceLeft(o, grid);
    input.action[InputType.KeyboardDown][Button.Right] = delegate bool(GameObject o) => movePieceRight(o, grid);
    input.action[InputType.KeyboardDown][Button.Down] = delegate bool(GameObject o) => movePieceDown(o, grid);
    input.action[InputType.KeyboardDown][Button.Up] = delegate bool(GameObject o) => rotatePieceCW(o, grid);
    input.action[InputType.KeyboardDown][Button.Space] = delegate bool(GameObject o) => rotatePieceCCW(o, grid);
    input.action[InputType.KeyboardDown][Button.Enter] = delegate bool(GameObject o) => dropPiece(o, grid);
}

void setBlockPosition(GameObject o) {
    CFallingPiece fpiece = o.getAlways!CFallingPiece();

    foreach(i; 0..4) {
        CBlock block = fpiece.blocks[i].get!CBlock();
        block.x = fpiece.x + fpiece.offset[fpiece.rotation][i].x;
        block.y = fpiece.y + fpiece.offset[fpiece.rotation][i].y;
    }
}







