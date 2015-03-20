module erlogtrisy2k.position;


import erlogtrisy2k.gameobject;
import erlogtrisy2k.system;
import erlogtrisy2k.component;


class CPosition: Component {
    int x, y;
    int xreal, yreal;

    this(int a, int b) {
        type = CType.Position;
        x = a;
        y = b;
    }
    this() {
        type = CType.Position;
    }
}





class SPosition : System {
    this () {
        requires ~= CType.Position;
    }
    ~this () {
    }



    override void initialize() {
    }
    override void addObject(GameObject o) {
    }
    override void removeObject(GameObject o) {
    }
    override void update(int ) {
        foreach(o; objects) {
            CPosition pos = o.get!CPosition();
            /*CParent parent = o.get!CParent();
            if (parent !is null) {
                CPosition parentpos = parent.get!CPosition();
                if (parentpos !is null) {
                    pos.xreal = parentpos.xreal + pos.x;
                    pos.yreal = parentpos.yreal + pos.y;
                }
                else {
                    pos.xreal = pos.x;
                    pos.yreal = pos.y;
                }
            }
            else {*/
                pos.xreal = pos.x;
                pos.yreal = pos.y;
            //}
        }
    }
}
