module erlogtrisy2k.scene;

import erlogtrisy2k.engine;


class Scene {
    Engine engine;
    void setEngine(Engine e) {
        engine = e;
    }
    abstract void initialize();
    abstract void suspend();
    abstract void unsuspend();
    abstract void destroy();
}



