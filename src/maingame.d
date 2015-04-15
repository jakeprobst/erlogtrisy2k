module erlogtrisy2k.maingame;



import erlogtrisy2k.scene;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.block;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;

import erlogtrisy2k.fallingpiece;
import erlogtrisy2k.nextpiece;
import erlogtrisy2k.grid;
import erlogtrisy2k.checkmatches;
import erlogtrisy2k.input;
import erlogtrisy2k.memory;
import erlogtrisy2k.kanjidatabase;

import std.stdio;







class MainGame: Scene {
    int grade, level;
    bool gravity, weightedrandom;

    NextPiece nextpiece;
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


    /*void makeNextPiece() {
        GameObject piece = make!GameObject;
        makeNextBlock(piece);
        //piece.add(make!CFallingBlock);


    }*/

    /*bool goback(GameObject o) {
        engine.popScene();
        return true;
    }*/


    override void start() {
        super.start();
        engine.addSystem(make!SFallingPiece);
        //engine.addSystem(make!SNextPiece);
        engine.addSystem(make!SGrid);
        //engine.addSystem(make!SCheckMatches);

        nextpiece = make!NextPiece;

        GameObject background = make!GameObject;
        CTexture tex = background.getAlways!CTexture();
        tex.texture = _T.loadFile("resources/images/maingame/background.png");
        tex.layer = Layer.Background;
        background.add(make!CPosition(0,0));


        grid = make!GameObject;
        makeGrid(grid);


        //GameObject nextpiece = make!GameObject;
        //makeNextPiece(nextpiece);
        //makeFallingPiece(nextpiece, PieceType.L);







    }




    override void stop() {
        super.stop();
        unmake(nextpiece);
        engine.removeSystem!SGrid();
        engine.removeSystem!SFallingPiece();
    }
}
