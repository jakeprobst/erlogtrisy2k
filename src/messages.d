module erlogtrisy2k.messages;

import erlogtrisy2k.gameobject;
import derelict.sdl2.sdl;





class Message {
}

class MNewObject: Message {
    GameObject object;

    this(GameObject o) {
        object = o;
    }
}

class MObjectDeleted: Message {
    GameObject object;

    this(GameObject o) {
        object = o;
    }
}

class MComponentChange: Message {
    GameObject object;

    this(GameObject o) {
        object = o;
    }
}

class MQuitProgram: Message {
}

class MRendererCreated: Message {
    SDL_Renderer* renderer;
    this(SDL_Renderer* r) {
        renderer = r;
    }
}














