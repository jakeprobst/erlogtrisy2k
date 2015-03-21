module erlogtrisy2k.maingame;



import erlogtrisy2k.scene;










class MainGame: Scene {
    int grade, level;
    bool gravity, weightedrandom;



    this(long g, long l, bool grav, bool weighted) {
        grade = cast(int)g;
        level = cast(int)l;
        gravity = grav;
        weightedrandom = weighted;
    }
    ~this() {
    }





    override void initialize() {
    }
    override void suspend() {
    }
    override void unsuspend() {
    }
    override void destroy() {
    }
}
