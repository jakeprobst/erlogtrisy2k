module erlogtrisy2k.texture;

import erlogtrisy2k.system;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.engine;
import erlogtrisy2k.component;
import erlogtrisy2k.render;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.memory;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import std.stdio;
import std.string;


class LoadImageError: Exception {
    this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}

class Texture {
    int id = -1;
    int w, h;

    this(int tid) {
        id = tid;
        _T.incRef(id);
    }

    this(Texture t) {
        _T.decRef(id);
        id = t.id;
        _T.incRef(id);
        w = t.w;
        h = t.h;
    }

    ~this() {
        _T.decRef(id);
    }
}

enum Layer {
    Background,
    Default,
    Block,
    BlockText,
}

class CTexture: Component {
    Texture _texture = null;
    Layer layer = Layer.Default;
    bool visible = true;

    this() {
    }

    @property Texture texture() {
        return _texture;
    }

    @property Texture texture(Texture t) {
        if (texture !is null) {
            unmake(_texture);
        }
        return _texture = t;
    }

    ~this() {
        unmake(_texture);
    }
}


class TextureManager {
    static int TID = 0;
    SDL_Renderer* renderer = null;

    //int[string] path_texid;
    int[int] texid_refcount;
    SDL_Texture*[int] texid_texture;

    this() {
        _M.register(this, &objectDeleted);
        _M.register(this, &setRenderer);

    }
    ~this() {
        writeln("unfreed textures:");
        foreach(texid, refcount; texid_refcount) {
            writefln("%d: %d", texid, refcount);
        }
    }

    Texture loadFile(string path) {
        if (renderer is null) {
            throw new Exception("loadFile: no renderer initialized");
        }

        Texture tex;
        /*int* texid = (path in path_texid);
        if (texid is null) {
            SDL_Texture* texture = IMG_LoadTexture(renderer, path.toStringz());
            tex = new Texture(TID++);
            texid_texture[tex.id] = texture;
            path_texid[path] = tex.id;
        }
        else {
            if (!(path_texid[path] in texid_refcount)) {
                SDL_Texture* texture = IMG_LoadTexture(renderer, path.toStringz());
                tex = new Texture(TID++);
                texid_texture[tex.id] = texture;
                path_texid[path] = tex.id;
            }
            else {
                tex = new Texture(path_texid[path]);
            }
        }*/

        SDL_Texture* texture = IMG_LoadTexture(renderer, path.toStringz());
        if (texture == null) {
            throw new LoadImageError("could not load: " ~ path);
        }
        tex = make!Texture(TID++);
        texid_texture[tex.id] = texture;

        SDL_QueryTexture(get(tex), null, null, &tex.w, &tex.h);
        return tex;
    }

    void objectDeleted(MObjectDeleted m) {
    }

    SDL_Texture* get(Texture tex) {
        return texid_texture[tex.id];
    }

    void incRef(int id) {
        if (id == -1) {
            return;
        }
        texid_refcount[id]++;
    }

    void decRef(int id) {
        if (!(id in texid_refcount) || (id == -1)) {
            return;
        }
        texid_refcount[id]--;
        if (texid_refcount[id] == 0) {
            unloadTexture(id);
        }
    }

    void unloadTexture(int id) {
        SDL_DestroyTexture(texid_texture[id]);
        texid_refcount.remove(id);
        texid_texture.remove(id);
    }

    Texture makeTexture(ubyte[] texbytes, int width, int height) {
        Texture tex = make!Texture(TID++);
        tex.w = width;
        tex.h = height;

        SDL_Texture* st = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888,
                                    SDL_TEXTUREACCESS_STREAMING, width, height);

        SDL_SetTextureBlendMode(st, SDL_BLENDMODE_BLEND);

        ubyte* data;
        int pitch;
        SDL_LockTexture(st, null, cast(void**)&data, &pitch);
        for(int i = 0; i < width*height*4; i++) {
            data[i] = texbytes[i];
        }

        SDL_UnlockTexture(st);
        texid_texture[tex.id] = st;

        return tex;
    }

    void setRenderer(MRendererCreated m) {
        renderer = m.renderer;
    }
}


TextureManager _T;
static this() {
    _T = make!TextureManager;
}





