module erlogtrisy2k.render;

import erlogtrisy2k.system;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.component;
import erlogtrisy2k.texture;
import erlogtrisy2k.messagebus;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

import std.stdio;
import std.string;


SDL_Rect toRect(CPosition pos, CTexture tex) {
    SDL_Rect r;
    r.x = pos.x;
    r.y = pos.y;
    r.w = tex.texture.w;
    r.h = tex.texture.h;
    return r;
}



class SRender: System {
    string title;
    int width, height;
    SDL_Window* window;
    SDL_Renderer* renderer;

    this(string t, int w, int h) {
        title = t;
        width = w;
        height = h;

        requires ~= CType.Texture;
        requires ~= CType.Position;
    }

    ~this() {
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
    }

    SDL_Renderer* getRenderer() {
        return renderer;
    }


    override void initialize() {
        DerelictSDL2.load();
        DerelictSDL2Image.load();
        SDL_Init(SDL_INIT_VIDEO);
        window = SDL_CreateWindow(title.toStringz, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, 0);
        renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
        _M.send(new MRendererCreated(renderer));
    }

    override void addObject(GameObject) {
    }
    override void removeObject(GameObject) {
    }
    override void update() {
        SDL_RenderClear(renderer);
        foreach(o; objects) {
            CTexture tex = o.get!CTexture();
            CPosition pos = o.get!CPosition();
            SDL_Rect r = toRect(pos,tex);
            SDL_RenderCopy(renderer, _T.get(tex.texture), null, &r);
        }
        SDL_RenderPresent(renderer);
    }

}
