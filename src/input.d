module erlogtrisy2k.input;



import erlogtrisy2k.system;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.gameobject;
import erlogtrisy2k.component;
import erlogtrisy2k.sortedlist;
import erlogtrisy2k.memory;

import derelict.sdl2.sdl;

import std.stdio;
import core.exception;

enum Priority {
    Default,
}

enum InputType {
    None,
    KeyboardUp,
    KeyboardDown,
    MouseUp,
    MouseDown,
}

enum Button {
    None,
    Up,
    Down,
    Left,
    Right,
    Space,
    Enter,
    Escape,

    MouseLeft,
    MouseRight,
    MouseMiddle,
}


enum InputType[int] InputTypeLookup = [
    SDL_KEYDOWN : InputType.KeyboardDown,
    SDL_KEYUP : InputType.KeyboardUp,
    SDL_MOUSEBUTTONDOWN : InputType.MouseDown,
    SDL_MOUSEBUTTONUP : InputType.MouseUp,
];

enum Button[int] ButtonLookup = [
    SDLK_UP : Button.Up,
    SDLK_DOWN : Button.Down,
    SDLK_LEFT : Button.Left,
    SDLK_RIGHT : Button.Right,
    SDLK_SPACE : Button.Space,
    SDLK_RETURN : Button.Enter,
    SDLK_ESCAPE : Button.Escape,

    SDL_BUTTON_LEFT : Button.MouseLeft,
    SDL_BUTTON_RIGHT : Button.MouseRight,
    SDL_BUTTON_MIDDLE : Button.MouseMiddle,
];



class CInput: Component {
    int priority = Priority.Default;
    bool active = true;
    bool delegate(GameObject o)[Button][InputType] action;
    bool delegate(GameObject o, int x, int y) mouse = null;
}

class SInput: System {
    SortedList!(GameObject) contexts;

    this() {
        requires ~= CInput.classinfo.name;

        bool input_cmp(GameObject o1, GameObject o2) {
           return (o1.get!CInput().priority < o2.get!CInput().priority);
        }

        contexts = make!(SortedList!(GameObject))(&input_cmp);
    }

    ~this() {
        unmake(contexts);
    }

    override void start() {}

    override void addObject(GameObject o) {
        contexts.insert(o);
    }
    override void removeObject(GameObject o) {
        contexts.remove(o);
    }
    override void update(int frame) {
        SDL_Event event;
        while(SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                _M.send(make!MQuitProgram());
            }

            InputType type = InputType.None;
            Button button = Button.None;

            if (event.type == SDL_KEYDOWN || event.type == SDL_KEYUP) {
                try {
                    type = InputTypeLookup[event.type];
                    button = ButtonLookup[event.key.keysym.sym];
                } catch (RangeError e) {
                }
            }
            else if (event.type == SDL_MOUSEBUTTONDOWN || event.type == SDL_MOUSEBUTTONUP) {
                try {
                    type = InputTypeLookup[event.type];
                    button = ButtonLookup[event.button.button];
                } catch (RangeError e) {
                }
            }
            else if (event.type == SDL_MOUSEMOTION) {
                foreach(obj; contexts) {
                    CInput input = obj.get!CInput();
                    if (input.mouse !is null && input.active) {
                        if (input.mouse(obj, event.motion.x, event.motion.y)) {
                            break;
                        }
                    }
                }
                continue; // don't need the loops below with mouse motion
            }

            if (type == InputType.None || button is Button.None) {
                continue;
            }

            foreach(obj; contexts) {
                CInput input = obj.get!CInput();
                if (!input.active) {
                    continue;
                }
                if (type in input.action) {
                    if (button in input.action[type]) {
                        if (input.action[type][button](obj)) {
                            break;
                        }
                    }
                }
            }
        }
    }

}
