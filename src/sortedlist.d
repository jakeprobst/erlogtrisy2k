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
        for(int i = 0; i < data.length; i++) {
            if (!cmp_lt(item, data[i])) {
                data = data[0..i] ~ item ~ data[i..$];
                return;
            }
        }
        data ~= item;
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

    // Test empty list equality
    assert(list == []);

    // Test single-element list equality
    list.insert(12);
    assert(list == [12]);
    // Test empty list inequality
    assert(list != []);

    // Test list with multiple elements
    list.insert(5);
    assert(list == [5, 12]);
    list.insert(7);
    assert(list == [5, 7, 12]);
    list.insert(22);
    assert(list == [5, 7, 12, 22]);
    assert(list != [5, 7, 22, 12]);

    // Test remove from middle
    list.remove(7);
    assert(list == [5, 12, 22]);
    // Test remove from start
    list.remove(5);
    assert(list == [12, 22]);
    // Test remove from end
    list.remove(22);
    assert(list == [12]);

    // Test min and max insertions
    list.insert(int.max);
    list.insert(6);
    list.insert(int.min);

    assert(list == [int.min, 6, 12, int.max]);

    // Test duplicate element insertion
    list.insert(int.max);
    assert(list == [int.min, 6, 12, int.max, int.max]);
    list.insert(int.min);
    assert(list == [int.min, int.min, 6, 12, int.max, int.max]);
    list.insert(12);
    assert(list == [int.min, int.min, 6, 12, 12, int.max, int.max]);

    delete list;
}







