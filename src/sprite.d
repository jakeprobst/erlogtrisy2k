module erlogtrisy2k.sprite;

import erlogtrisy2k.gameobject;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.position;


void MakeSprite(GameObject o, string path, int x, int y) {
    CTexture tex = o.getAlways!CTexture();
    tex.texture = _T.loadFile("resources/images/" ~ path);

    CPosition pos = o.getAlways!CPosition();
    pos.x = x;
    pos.y = y;
}
