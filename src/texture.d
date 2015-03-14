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


struct Texture {
    int id;
    int w, h;
}


class CTexture: Component {
    Texture texture;
}


class TextureManager {
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

    Texture loadFile(string path) {
        if (renderer is null) {
            throw new Exception("loadFile: no renderer initialized");
        }

        Texture tex;
        int* texid = (path in path_texid);
        if (texid is null) {
            SDL_Texture* texture = IMG_LoadTexture(renderer, path.toStringz());
            tex.id = TID++;
            texid_texture[tex.id] = texture;
        }
        else {
            tex.id = *texid;
            texid_refcount[*texid]++;
        }

        SDL_QueryTexture(get(tex), null, null, &tex.w, &tex.h);
        return tex;

    }

    void objectDeleted(MObjectDeleted m) {
        CTexture tex = m.object.get!CTexture();
        if (tex) {
            unloadTexture(tex.texture);
        }
    }

    SDL_Texture* get(Texture tex) {
        return texid_texture[tex.id];
    }

    void unloadTexture(Texture tex) {
        if (tex.id != -1) {
            texid_refcount[tex.id]--;
            if (texid_refcount[tex.id] == 0) {
                SDL_DestroyTexture(texid_texture[tex.id]);
                texid_refcount.remove(tex.id);
                texid_texture.remove(tex.id);
            }
            tex.id = -1;
        }
    }

    void setRenderer(MRendererCreated m) {
        renderer = m.renderer;
    }
}


TextureManager _T;
static this() {
    _T = new TextureManager;
}





