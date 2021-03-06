module erlogtrisy2k.animation;

import erlogtrisy2k.gameobject;
import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.memory;

import std.stdio;


class CAnimation : Component {
    Texture[] textures;
    int index = 0;
    int changerate = 1;
    int lastchange = 0;
    bool animating = true;
    bool loop = true;
}





class SAnimation : System {
    int lastframe = 0;

    this() {
        requires ~= CAnimation.classinfo.name;
        requires ~= CTexture.classinfo.name;
    }
    ~this() {

    }

    override void start() {
    }
    override void addObject(GameObject o) {
        o.get!CAnimation().lastchange = lastframe;
        o.get!CTexture().texture = make!Texture(o.get!CAnimation().textures[0]);
    }
    override void removeObject(GameObject o) {
    }
    override void update(int frame) {
        foreach(o; objects) {
            CAnimation anim = o.get!CAnimation();
            if (!anim.animating) {
                continue;
            }

            if (!anim.loop && anim.index == anim.textures.length-1) {
                continue;
            }

            if (anim.changerate <= frame - anim.lastchange) {
                anim.lastchange = anim.lastchange + anim.changerate;

                CTexture tex = o.get!CTexture();
                anim.index++;
                anim.index %= anim.textures.length;
                tex.texture = make!Texture(anim.textures[anim.index]);
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
    anim.changerate = 10;
    o.add(make!CTexture);
}




