module erlogtrisy2k.avltree;

import std.stdio;
import std.algorithm;
import std.string;

class AvlTreeKeyError: Exception {
    this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}


class AvlTree(K, V, alias bool ownData = false) {
    class AvlNode {
        K key;
        V value;
        int height = 1;
        AvlNode left = null;
        AvlNode right = null;

        this(K k, V v) {
            key = k;
            value = v;
        }

        ~this() {
            static if (ownData) {
                delete key;
                delete value;
            }
        }

        void deleteChildren() {
            if (left !is null) {
                left.deleteChildren();
                delete left;
            }
            if (right !is null) {
                right.deleteChildren();
                delete right;
            }
        }

        override string toString() {
            //return "AvlNode(" + key + ": " + value + ")";
            return format("AvlNode(%s: %s)", key, value);
        }
    }

    int delegate(K, K) cmp_lt;
    AvlNode treeroot = null;

    this(int delegate(K, K) cmp) {
        cmp_lt = cmp;
    }

    ~this() {
        if (treeroot !is null) {
            treeroot.deleteChildren();
            delete treeroot;
        }
    }

    private int _height(AvlNode node) {
        if (node is null) {
            return 0;
        }
        return node.height;
    }

    private int _balance(AvlNode node) {
        if (node is null) {
            return 0;
        }
        return _height(node.left) - _height(node.right);
    }

    private AvlNode _rotateLeft(AvlNode node) {
        AvlNode tmp = node.right;
        node.right = tmp.left;
        tmp.left = node;

        node.height = max(_height(node.left), _height(node.right)) + 1;
        tmp.height = max(_height(tmp.left), _height(tmp.right)) + 1;
        return tmp;
    }

    private AvlNode _rotateRight(AvlNode node) {
        AvlNode tmp = node.left;
        node.left = tmp.right;
        tmp.right = node;

        node.height = max(_height(node.left), _height(node.right)) + 1;
        tmp.height = max(_height(tmp.left), _height(tmp.right)) + 1;
        return tmp;
    }

    private AvlNode _insert(AvlNode root, AvlNode node) {
        if (root is null) {
            return node;
        }

        int cmp = cmp_lt(root.key, node.key);
        if (cmp < 0) {
            root.left = _insert(root.left, node);
        }
        else if (cmp > 0) {
            root.right = _insert(root.right, node);
        }
        else {
            static if (ownData) {
                delete root.value;
            }
            root.value = node.value;
            delete node;
            return root;
        }

        root.height = max(_height(root.right), _height(root.left)) + 1;
        int balance = _balance(root);
        if (balance > 1 && cmp_lt(root.left.key, node.key) < 0) {
            return _rotateRight(root);
        }
        if (balance > 1 && cmp_lt(root.left.key, node.key) > 0) {
            root.left = _rotateLeft(root.left);
            return _rotateRight(root);
        }
        if (balance < -1 && cmp_lt(root.right.key, node.key) > 0) {
            return _rotateLeft(root);
        }
        if (balance < -1 && cmp_lt(root.right.key, node.key) < 0) {
            root.right = _rotateRight(root.right);
            return _rotateLeft(root);
        }

        return root;
    }

    bool insert(K key, V value) {
        auto node = new AvlNode(key, value);

        treeroot = _insert(treeroot, node);
        return true;
    }

    private AvlNode _minValueNode(AvlNode node) {
        if (node.left is null) {
            return node;
        }
        return _minValueNode(node.left);
    }

    private AvlNode _remove(AvlNode node, K key) {
        if (node is null) {
            return null;
        }

        int cmp = cmp_lt(node.key, key);
        if (cmp < 0) {
            node.left = _remove(node.left, key);
        }
        else if (cmp > 0) {
            node.right = _remove(node.right, key);
        }
        else {
            if (node.left is null && node.right is null) {
                delete node;
                return null;
            }
            else if (node.right is null) {
                AvlNode tmp = node;
                node = node.left;
                delete tmp;
            }
            else if (node.left is null) {
                AvlNode tmp = node;
                node = node.right;
                delete tmp;
            }
            else {
                AvlNode tmp = _minValueNode(node.right);

                K tmpkey = tmp.key;
                V tmpval = tmp.value;
                node.right = _remove(node.right, tmp.key);

                node.key = tmpkey;
                node.value = tmpval;
            }
        }

        if (node is null) {
            return null;
        }

        node.height = max(_height(node.left), _height(node.right)) + 1;
        int balance = _balance(node);

        if (balance > 1 && _balance(node.left) >= 0) {
            return _rotateRight(node);
        }
        else if (balance > 1 && _balance(node.left) < 0) {
            node.left = _rotateLeft(node.left);
            return _rotateRight(node);
        }
        else if (balance < -1 && _balance(node.right) <= 0) {
            return _rotateLeft(node);
        }
        else if (balance < -1 && _balance(node.right) > 0) {
            node.right = _rotateRight(node.right);
            return _rotateLeft(node);
        }

        return node;
    }


    void remove(K key) {
        treeroot = _remove(treeroot, key);
    }

    private AvlNode _get(AvlNode node, K key) {
        if (node is null) {
            return null;
        }

        int cmp = cmp_lt(node.key, key);
        if (cmp < 0) {
            return _get(node.left, key);
        }
        else if (cmp > 0) {
            return _get(node.right, key);
        }
        else {
            return node;
        }

    }

    ref V get(K key) {
        AvlNode node = _get(treeroot, key);
        if (node is null) {
            throw new AvlTreeKeyError(format("No key: %d", key));
        }
        return node.value;
    }


    bool exists(K key) {
        AvlNode node = _get(treeroot, key);
        if (node is null) {
            return false;
        }
        return true;
    }

    private void subApply(AvlNode node, int delegate(ref K, ref V) func) {
        if (node is null) {
            return;
        }
        subApply(node.left, func);
        func(node.key, node.value);
        subApply(node.right, func);
    }

    int opApply(int delegate(ref K, ref V) func) {
        subApply(treeroot, func);
        return 1;
    }

    private void subApply(AvlNode node, int delegate(ref K) func) {
        if (node is null) {
            return;
        }
        subApply(node.left, func);
        func(node.key);
        subApply(node.right, func);
    }

    int opApply(int delegate(ref K) func) {
        subApply(treeroot, func);
        return 1;
    }


    ref V opIndex(K key) {
        return get(key);

    }
}






unittest {
    auto tree = new AvlTree!(int, string)((a, b) => b - a);

    //     4
    // 2       6
    //     3       8
    tree.insert(4, "four");
    tree.insert(2, "two");
    tree.insert(8, "eight");
    tree.insert(3, "three");
    tree.insert(6, "six");

    assert(tree.treeroot.key == 4);
    assert(tree.treeroot.left.key == 2);
    assert(tree.treeroot.left.value == "two");

    tree.insert(2, "two-two");
    assert(tree.treeroot.left.key == 2);
    assert(tree.treeroot.left.value == "two-two");

    assert(tree.exists(2));
    assert(!tree.exists(5));

    tree.remove(4);
    assert(tree.treeroot.key == 6);
    assert(tree.treeroot.right.key == 8);
    assert(tree.treeroot.right.right is null);

    tree.insert(5, "five");
    assert(tree.treeroot.key == 6);

    tree.insert(4, "newfour");
    assert(tree.treeroot.key == 5);
    assert(tree.treeroot.left.value == "three");
    assert(tree.treeroot.left.right.value == "newfour");

    assert(tree.get(6) == "six");

    try {
        tree.get(12);
        assert(false);
    }
    catch (AvlTreeKeyError e) {
        assert(e.msg == "No key: 12");
    }
    try {
        tree[12];
        assert(false);
    }
    catch (AvlTreeKeyError e) {
    }

    assert(tree[2] == "two-two");
    tree[5] = "oldfive";
    tree[6] ~= "add";

    int keys[];
    string values[];
    foreach(k, v; tree) {
        keys ~= k;
        values ~= v;
    }

    assert(keys == [2, 3, 4, 5, 6, 8]);
    assert(values == ["two-two", "three", "newfour", "oldfive", "sixadd", "eight"]);


    delete tree;
}
