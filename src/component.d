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
    Parent,
    End,
}




class Component {
    CType type = CType.None;

    bool opEquals(CType c) {
        return type == c;
    }
}




/*class CParent : Component {
    GameObject parent = null;

    this(GameObject p) {
        type = CType.Parent
        parent = p;
    }
}

class CChildren : Component {
    GameObject[] children;


}*/




