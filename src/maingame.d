module erlogtrisy2k.maingame;



import erlogtrisy2k.scene;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.block;
import erlogtrisy2k.component;

import erlogtrisy2k.fallingblock;
import erlogtrisy2k.grid;
import erlogtrisy2k.checkmatches;
import erlogtrisy2k.input;

import std.stdio;







class MainGame: Scene {
    int grade, level;
    bool gravity, weightedrandom;

    GameObject grid;
    //GameObject[] blocks;


    this(long g, long l, bool grav, bool weighted) {
        grade = cast(int)g;
        level = cast(int)l;
        gravity = grav;
        weightedrandom = weighted;



    }
    ~this() {

    }


    void makeNewPiece() {
        GameObject piece = new GameObject;
        piece.add(new CFallingBlock);

    }

    /*bool goback(GameObject o) {
        engine.popScene();
        return true;
    }*/


    override void initialize() {
        engine.addSystem(new SFallingBlock);
        engine.addSystem(new SGrid);
        engine.addSystem(new SCheckMatches);

        grid = new GameObject;
        grid.add(new CGrid);
        grid.add(new CPosition);


        makeNewPiece();







    }




    override void suspend() {
    }
    override void unsuspend() {
    }
    override void destroy() {
        engine.removeSystem!SCheckMatches();
        engine.removeSystem!SGrid();
        engine.removeSystem!SFallingBlock();

        delete grid;


    }
}
