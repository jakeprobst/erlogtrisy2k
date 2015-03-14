module erlogtrisy2k.sortedlist;


import std.algorithm;
import std.functional;

class SortedList(T) {
    T[] data;
    bool delegate(T, T) cmp_lt;

    this(bool delegate(T, T) c) {
        cmp_lt = c;
    }

    this(bool function(T, T) c) {
        cmp_lt = toDelegate(c);
    }

    ~this () {

    }

    void insert(T item) {
        if (data.length == 0) {
            data ~= item;
        }
        else {
            for(int i = 0; i < data.length; i++) {
                if (!cmp_lt(item, data[i])) {
                    data = data[0..i] ~ item ~ data[i..$];
                    return;
                }
            }
            data ~= item;
        }
    }

    void remove(T item) {
        data = data.remove!(a => a == item);
    }

    int opApply(int delegate(ref T) func) {
        int result;
        foreach(d; data) {
            result = func(d);
            if (result != 0)
                break;
        }
        return result;
    }

    T opIndex(size_t index) {
        return data[index];
    }

    bool opEquals(T[] op) {
        if (op.length != data.length) {
            return false;
        }

        for(int i = 0; i < data.length; i++) {
            if (data[i] != op[i]) {
                return false;
            }
        }

        return true;
    }
}


//fuck you flamercockz
unittest {
    bool intcmp(int a, int b) {
        return a > b;
    }

    auto list = new SortedList!(int)(&intcmp);
    list.insert(12);
    assert(list == [12]);
    list.insert(5);
    assert(list == [5, 12]);
    list.insert(7);
    assert(list == [5, 7, 12]);
    list.insert(22);
    assert(list == [5, 7, 12, 22]);
    assert(list != [5, 7, 22, 12]);

    list.remove(7);
    assert(list == [5, 12, 22]);

    list.insert(6);
    list.insert(int.max);
    list.insert(int.min);
    assert(list == [int.min, 5, 6, 12, 22, int.max]);
    assert(list[0] == int.min);
    assert(list[1] == 5);
    assert(list[2] == 6);
    assert(list[3] == 12);
    assert(list[4] == 22);
    assert(list[5] == int.max);

    delete list;
}







