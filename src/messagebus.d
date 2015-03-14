module erlogtrisy2k.messagebus;

public import erlogtrisy2k.messages;

import std.stdio;
import std.container;
import std.array;
import std.algorithm;
import std.traits;

class Callback {
    void* id;
    //int id;
    void delegate(Message) func;

    this(void* t, void delegate(Message) f) {
    //this(int t, void delegate(Message) f) {
        id = t;
        func = f;
    }

    bool opEquals(void* t) {
    //bool opEquals(int t) {
        return id == t;
    }
}

class MessageBus {
    Callback[][MsgType.max] callbacks;

    this() {
    }
    ~this() {}

    void send(Message msg) {
        foreach(cb; callbacks[msg.type]) {
            cb.func(msg);
        }
        delete msg;
    }

    void register(T, M)(T id, MsgType type, void delegate(M) cb) {
        callbacks[cast(int)type] ~= new Callback(cast(void*)id, cast(void delegate(Message))cb);
    }
    /*void register(M)(int id, MsgType type, void delegate(M) cb) {
        callbacks[cast(int)type] ~= new Callback(id, cast(void delegate(Message))cb);
    }*/

    void unregister(T)(T id) {
        foreach(type; callbacks) {
            type.remove(find(type, cast(void)id));
        }
    }
    /*void unregister(int id) {
        foreach(type; callbacks) {
            type.remove(find(type, id));
        }
    }*/
}


MessageBus _M;
static this() {
   _M = new MessageBus;
}
