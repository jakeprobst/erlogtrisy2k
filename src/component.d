module erlogtrisy2k.component;

import erlogtrisy2k.gameobject;


import derelict.sdl2.sdl;


enum CType {
    None,
    Texture,
    Position,
    Velocity,
    Input,
    Button,
    Animation,
    End,
}




class Component {
    CType type = CType.None;

    bool opEquals(CType c) {
        return type == c;
    }
}

class CPosition: Component {
    int x, y;

    this(int a, int b) {
        type = CType.Position;
        x = a;
        y = b;
    }
    this() {
        type = CType.Position;
    }
}






