module erlogtrisy2k.animation;

import erlogtrisy2k.gameobject;
import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;

import std.stdio;


class CAnimation : Component {
    Texture[] textures;
    int index = 0;
    int changerate = 1;
    int lastchange = 0;
    bool animating = true;
    bool loop = true;

    this() {
        type = CType.Animation;
    }
}





class SAnimation : System {
    int lastframe = 0;

    this() {
        requires ~= CType.Animation;
        requires ~= CType.Texture;
    }
    ~this() {

    }

    override void initialize() {
    }
    override void addObject(GameObject o) {
        o.get!CAnimation().lastchange = lastframe;
    }
    override void removeObject(GameObject o) {
    }
    override void update(int frame) {
        foreach(o; objects) {
            CAnimation anim = o.get!CAnimation();
            if (!anim.animating) {
                continue;
            }

            if (anim.changerate <= frame - anim.lastchange) {
                anim.lastchange = anim.lastchange + anim.changerate;

                CTexture tex = o.get!CTexture();
                tex.texture = anim.textures[anim.index++ % anim.textures.length];
            }
        }
        lastframe = frame;
    }
}



void MakeAnimation(GameObject o, string[] images) {
    CAnimation anim = o.getAlways!CAnimation();

    foreach(i; images) {
        anim.textures ~= _T.loadFile("resources/images/" ~ i);
    }

    CPosition pos = o.getAlways!CPosition();
    pos.x = 100;
    pos.y = 100;

    o.add(new CTexture);

    anim.changerate = 10;



}




