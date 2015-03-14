module erlogtrisy2k.component;

import derelict.sdl2.sdl;


enum CType {
    Texture,
    Position,
    Velocity,
    Input,
    Button,
    End,
}




class Component {
    CType type;

    bool opEquals(CType c) {
        return type == c;
    }
}

enum TexAction {
    LoadImage,
    SetSurface,
    Nothing,
}

class CTexture: Component {
    int texid;
    int w, h;


    /*int texid;
    SDL_Texture* texture = null;
    TexAction action = TexAction.Nothing;
    string loadpath = null;
    SDL_Surface* surface = null;
    int w,h;

    this() {
    }
    ~this() {
    }

    void LoadImage(string p) {
        action = TexAction.LoadImage;
        loadpath = p;
    }

    void SetSurface(SDL_Surface* s) {
        action = TexAction.SetSurface;
        surface = s;
    }*/
}


class CPosition: Component {
    int x,y;

    this(int a, int b) {
        type = CType.Position;
        x = a;
        y = b;
    }
}










