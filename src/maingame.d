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
        GameObject piece = new GameObject;
        makeNextBlock(piece);
        //piece.add(new CFallingBlock);


    }*/

    /*bool goback(GameObject o) {
        engine.popScene();
        return true;
    }*/


    override void initialize() {
        super.initialize();
        engine.addSystem(new SFallingPiece);
        //engine.addSystem(new SNextPiece);
        engine.addSystem(new SGrid);
        //engine.addSystem(new SCheckMatches);

        nextpiece = new NextPiece;

        GameObject background = new GameObject;
        CTexture tex = background.getAlways!CTexture();
        tex.texture = _T.loadFile("resources/images/maingame/background.png");
        tex.layer = Layer.Background;
        background.add(new CPosition(0,0));


        grid = new GameObject;
        makeGrid(grid);


        //GameObject nextpiece = new GameObject;
        //makeNextPiece(nextpiece);
        //makeFallingPiece(nextpiece, PieceType.L);







    }




    override void destroy() {
        super.destroy();
        //engine.removeSystem!SCheckMatches();
        delete nextpiece;
        engine.removeSystem!SGrid();
        engine.removeSystem!SFallingPiece();
    }
}
