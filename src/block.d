module erlogtrisy2k.block;

import erlogtrisy2k.gameobject;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.fallingblock;

//const int WIDTH = 10;
//const int HEIGHT = 18;



class CBlock: Component {
    wchar kanji;
    int x, y;



    this() {

    }
    ~this() {

    }

}






void makeBlock(GameObject block, BlockType type,int x, int y)
{
    CBlock b = block.getAlways!CBlock();
    b.x = x;
    b.y = y;

    CTexture tex = block.getAlways!CTexture();
    tex.texture = _T.loadFile("resources/images/blue.png");
    tex.layer = Layer.Block;

    CPosition pos = block.getAlways!CPosition();



}
