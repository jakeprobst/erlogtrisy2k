module erlogtrisy2k.messagebus;

public import erlogtrisy2k.messages;
import erlogtrisy2k.memory;

import std.stdio;
import std.container;
import std.array;
import std.algorithm;
import std.traits;
import std.string;

class Callback {
    void* id;
    void delegate(Message) func;

    this(void* t, void delegate(Message) f) {
        id = t;
        func = f;
    }

    bool opEquals(void* t) {
        return id == t;
    }

    override string toString() {
        return format("%s(%s, %s)", this.classinfo.name, id, func);
    }
}

class MessageBus {
    Callback[][string] callbacks;

    this() {
    }
    ~this() {
    }

    void send(M)(M msg) {
        if (M.classinfo.name in callbacks) {
            foreach(cb; callbacks[M.classinfo.name]) {
                cb.func(msg);
            }
        }
        unmake(msg);
    }

    void register(T, M)(T id, void delegate(M) cb) {
        callbacks[M.classinfo.name] ~= new Callback(cast(void*)id, cast(void delegate(Message))cb);
    }

    void unregister(T)(T id) {
        foreach(k,v; callbacks) {
            callbacks[k] = callbacks[k].remove!(a => a == cast(void*)id);
        }
    }
}


MessageBus _M;
static this() {
   _M = new MessageBus;
}
