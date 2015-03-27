module erlogtrisy2k.fallingblock;


import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.grid;
import erlogtrisy2k.messages;
import erlogtrisy2k.block;

import std.stdio;
import std.random;

enum BlockType {
    I,
    L,
    J,
    S,
    Z,
    O,
    T
}



class MNeedNewBlock: Message {
}


class CFallingBlock: Component {
    BlockType blocktype;
    int speed= 60*2; // number of frames before dropping
    int lastdrop;
    GameObject[4] blocks;

    this() {
        //blocktype = uniform!BlockType();
        blocktype = BlockType.L;


        if (blocktype == BlockType.L) {
            blocks[0] = new GameObject;
            makeBlock(blocks[0], blocktype, 6, 0);
            blocks[1] = new GameObject;
            makeBlock(blocks[1], blocktype, 6, 1);
            blocks[2] = new GameObject;
            makeBlock(blocks[2], blocktype, 6, 2);
            blocks[3] = new GameObject;
            makeBlock(blocks[3], blocktype, 7, 2);
        }







    }
    ~this() {
    }
}






class SFallingBlock: System {
    GameObject grid = null;
    GameObject fallingblock = null;

    this() {

    }
    ~this() {
    }



    override void initialize() {
    }
    override void addObject(GameObject o) {
        if (o.has!CFallingBlock()) {
            fallingblock = o;
        }
        else if (o.has!CGrid()) {
            grid = o;
        }
    }
    override void removeObject(GameObject o) {
        if (o == fallingblock) {
            fallingblock = null;
        }
        else if (o == grid) {
            grid = null;
        }
    }
    override void update(int frame) {
        if (fallingblock is null || grid is null) {
            return;
        }

        CFallingBlock fb = fallingblock.get!CFallingBlock();
        writefln("%d %d %d", frame, fb.speed, fb.lastdrop);
        if (frame > (fb.speed + fb.lastdrop)) {
            bool movedown = true;
            CGrid g = grid.get!CGrid();
            foreach(block; fb.blocks) {
                CBlock b = block.get!CBlock();
                if (g.blocks[b.x][b.y+1] !is null || b.y+1 > HEIGHT) {
                    movedown = false;
                    break;
                }
            }

            if (movedown) {
                foreach(block; fb.blocks) {
                    CBlock b = block.get!CBlock();
                    b.y++;
                }





                fb.lastdrop = frame;
            }
        }
    }
}
