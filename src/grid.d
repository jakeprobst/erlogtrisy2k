module erlogtrisy2k.grid;


import erlogtrisy2k.component;
import erlogtrisy2k.system;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.block;
import erlogtrisy2k.texture;
import erlogtrisy2k.messagebus;

import std.stdio;
import std.algorithm;

const int GRIDWIDTH = 10;
const int GRIDHEIGHT = 22;
const int GRIDX = 223;
const int GRIDY = 13;






/*class Grid {
    GameObject blocks[HEIGHT][WIDTH]; // blocks[x][y]

    this() {
        _M.register(this, &newBlock);
        _M.register(this, &blockMoved);
    }
    ~this() {
    }


    void newBlock(MNewBlock msg) {
    }

    void blockMoved(MBlockMoved msg) {
    }





}*/




class CGrid: Component {
    GameObject[GRIDHEIGHT][GRIDWIDTH] blocks;



    this() {
    }
    ~this() {
    }




}








class SGrid: System {
    GameObject grid;
    GameObject[] blocks;

    this() {
    }
    ~this() {
    }





    override void initialize() {
    }
    override void addObject(GameObject o) {
        if (o.has!CGrid()) {
            grid = o;
        }
        if (o.has!CBlock()) {
            blocks ~= o;
        }
    }
    override void removeObject(GameObject o) {
        if (o == grid) {
            grid = null;
        }
        if (blocks.find(o)) {
            blocks = blocks.remove!(a => a == o);
        }
    }
    override void update(int frame) {
        if (grid is null) {
            return;
        }
        CPosition gpos = grid.get!CPosition();
        CGrid ggrid = grid.get!CGrid();
        foreach(i; 0..GRIDWIDTH) {
            foreach(n; 0..GRIDHEIGHT) {
                ggrid.blocks[i][n] = null;
            }
        }
        foreach(b; blocks) {
            CBlock bblock = b.get!CBlock();
            CTexture btex = b.get!CTexture();
            if (bblock.y < 2) {
                btex.visible = false;
                continue;
            }
            btex.visible = true;

            CPosition bpos = b.get!CPosition();
            ggrid.blocks[bblock.x][bblock.y] = b;
            bpos.x = gpos.x + btex.texture.w*(bblock.x);
            bpos.y = gpos.y + btex.texture.h*(bblock.y-2); //-2 cause 2 block invisible buffer at the top
        }
    }
}



void makeGrid(GameObject o)
{
    CGrid grid = o.getAlways!CGrid();

    CPosition pos = o.getAlways!CPosition();
    pos.x = GRIDX;
    pos.y = GRIDY;
}



