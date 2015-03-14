module erlogtrisy2k.sprite;

import erlogtrisy2k.gameobject;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;


void MakeSprite(GameObject o, string path, int x, int y) {
    CTexture tex = o.get!CTexture();
    if (tex is null) {
        tex = new CTexture;
        o.add(tex);
    }
    tex.texture = _T.loadFile("resources/images/" ~ path);


    CPosition pos = o.get!CPosition();
    if (pos is null) {
        pos = new CPosition;
        o.add(pos);
    }
    pos.x = x;
    pos.y = y;
}
