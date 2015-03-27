module erlogtrisy2k.grid;


import erlogtrisy2k.component;
import erlogtrisy2k.system;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.block;
import erlogtrisy2k.texture;

import std.algorithm;

const int WIDTH = 12;
const int HEIGHT = 20;


class CGrid: Component {
    GameObject[HEIGHT][WIDTH] blocks;



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
        foreach(b; blocks) {
            CPosition bpos = b.get!CPosition();
            CBlock bblock = b.get!CBlock();
            CTexture btex = b.get!CTexture();
            bpos.x = gpos.x + btex.texture.w*bblock.x;
            bpos.y = gpos.y + btex.texture.h*bblock.y;
        }


    }
}





