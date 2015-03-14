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



class CPosition: Component {
    int x,y;

    this(int a, int b) {
        type = CType.Position;
        x = a;
        y = b;
    }
    this() {
        type = CType.Position;
    }
}










