module erlogtrisy2k.messages;

import erlogtrisy2k.gameobject;
import derelict.sdl2.sdl;

enum MsgType {
    NewObject,
    ObjectDeleted,
    ComponentChange,
    QuitProgram,
    RenderCreated,
    Keypress,
    End,
}




class Message {
    MsgType type;
}

class MNewObject: Message {
    GameObject object;

    this(GameObject o) {
        type = MsgType.NewObject;
        object = o;
    }
}

class MObjectDeleted: Message {
    GameObject object;

    this(GameObject o) {
        type = MsgType.ObjectDeleted;
        object = o;
    }
}

class MComponentChange: Message {
    GameObject object;

    this(GameObject o) {
        type = MsgType.ComponentChange;
        object = o;
    }
}

class MQuitProgram: Message {
    this() {
        type = MsgType.QuitProgram;
    }
}

class MRendererCreated: Message {
    SDL_Renderer* renderer;
    this(SDL_Renderer* r) {
        type = MsgType.RenderCreated;
        renderer = r;
    }
}














