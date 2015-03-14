module erlogtrisy2k.texture;

import erlogtrisy2k.system;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.engine;
import erlogtrisy2k.component;
import erlogtrisy2k.render;
import erlogtrisy2k.messagebus;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import std.string;


/*class STexture: System {
    SDL_Renderer* renderer;
    /*string[int] pathmap;
    int[int] refcount;
    int[SDL_Texture*] handle;* /

    this(SRender render) {
        requires ~= CType.Texture;
        renderer = render.getRenderer();
    }

    ~this() {
    }

    override void initialize() {
        /*renderer = engine.get!SRender().getRenderer();
        if (renderer is null) {
            throw new Exception("need SRender before STexture");
        }* /
    }

    /*void removeObject(GameObject o) {
        unload(o);
    }* /

    override void addObject(GameObject o) {}
    override void removeObject(GameObject o) {}

    override void update() {}


}*/


class Texture {
    static int TID = 0;
    SDL_Renderer* renderer = null;

    int[string] path_texid;
    int[int] texid_refcount;
    SDL_Texture*[int] texid_texture;

    this() {
        _M.register(this, MsgType.ObjectDeleted, &objectDeleted);
        _M.register(this, MsgType.RenderCreated, &setRenderer);

    }
    ~this() {
    }

    void loadFile(GameObject o, string path) {
        if (renderer is null) {
            throw new Exception("loadFile: no renderer initialized");
        }
        CTexture tex = o.get!CTexture();
        if (tex is null) {
            throw new Exception("loadFile: GameObject needs a CTexture.");
        }

        int* texid = (path in path_texid);
        if (texid is null) {
            SDL_Texture* texture = IMG_LoadTexture(renderer, path.toStringz());
            tex.texid = TID++;
            texid_texture[tex.texid] = texture;
        }
        else {
            tex.texid = *texid;
            texid_refcount[*texid]++;
        }

        SDL_QueryTexture(get(tex), null, null, &tex.w, &tex.h);

    }

    void objectDeleted(MObjectDeleted m) {
        unloadTexture(m.object)
    }

    SDL_Texture* get(CTexture tex) {
        return texid_texture[tex.texid];
    }

    void unloadTexture(int texid) {
        CTexture tex = m.object.get!CTexture();
        if (tex && tex.texid != -1) {
            texid_refcount[texid]--;
            if (texid_refcount[texid] == 0) {
                SDL_DestroyTexture(texid_texture[texid]);
                texid_refcount.remove(texid);
                texid_texture.remove(texid);
            }
            tex.texid = -1;
        }
    }

    void setRenderer(MRendererCreated m) {
        renderer = m.renderer;
    }
}











Texture _T;
static this() {
    _T = new Texture;
}





