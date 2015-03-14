module erlogtrisy2k.button;

import erlogtrisy2k.system;
import erlogtrisy2k.component;
import erlogtrisy2k.messagebus;
import erlogtrisy2k.gameobject;


/*class CButton: Component {
    delegate void(void) callback;
}*/


class SButton: System {
    this() {
        requires ~= CType.Button;
        requires ~= CType.Input;
        requires ~= CType.Position;
    }
    ~this() {}



    override void initialize() {}
    override void addObject(GameObject) {}
    override void removeObject(GameObject) {}
    override void update() {
        foreach(o; objects) {

        }
    }


}

GameObject MakeButton(int x, int y) {
    GameObject o = new GameObject;
    o.add(new CPosition(x,y));

    return o;
}
