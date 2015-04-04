module erlogtrisy2k.avltree;

import std.stdio;
import std.algorithm;


/*class ItemNotFound: Exception {
    this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}*/

class AvlNode(K, alias bool ownData) {
    K key;
    int height = 1;
    AvlNode!(K, ownData) left = null;
    AvlNode!(K, ownData) right = null;

    this(K k) {
        key = k;
    }

    ~this() {
        static if (ownData) {
            delete key;
        }
        delete left;
        delete right;
    }
}




class AvlTree(K, alias bool ownData = false) {
    alias Node = AvlNode!(K, ownData);
    int delegate(K, K) cmp_lt;
    Node treeroot = null;

    this(int delegate(K, K) cmp) {
        cmp_lt = cmp;
    }

    ~this() {
        delete treeroot;
    }

    int _height(Node node) {
        if (node is null) {
            return 0;
        }
        return node.height;
    }

    int _balance(Node node) {
        if (node is null) {
            return 0;
        }
        return _height(node.left) - _height(node.right);
    }

    private Node _rotateLeft(Node node) {
        Node tmp = node.right;
        node.right = tmp.left;
        tmp.left = node;

        node.height = max(_height(node.left), _height(node.right)) + 1;
        tmp.height = max(_height(tmp.left), _height(tmp.right)) + 1;
        return tmp;
    }

    private Node _rotateRight(Node node) {
        Node tmp = node.left;
        node.left = tmp.right;
        tmp.right = node;

        node.height = max(_height(node.left), _height(node.right)) + 1;
        tmp.height = max(_height(tmp.left), _height(tmp.right)) + 1;
        return tmp;
    }

    private Node _insert(Node root, Node node) {
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
            // oh hey they are equal!
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
        if (balance < -1 && cmp_lt(root.left.key, node.key) > 0) {
            return _rotateLeft(root);
        }
        if (balance < -1 && cmp_lt(root.left.key, node.key) < 0) {
            root.right = _rotateRight(root.right);
            return _rotateLeft(root);
        }

        return root;
    }

    bool insert(K key) {
        auto node = new Node(key);

        treeroot = _insert(treeroot, node);
        return true;
    }

    bool remove(K key) {
        return false;
    }

    private Node _exists(Node node, K key) {
        if (node is null) {
            return null;
        }

        int cmp = cmp_lt(node.key, key);
        if (cmp > 0) {
            return _exists(node.left, key);
        }
        else if (cmp < 0) {
            return _exists(node.right, key);
        }
        else {
            return node;
        }

    }

    bool exists(K key) {
        Node node = _exists(treeroot, key);
        if (node is null) {
            return false;
        }
        return true;
    }



    void subApply(Node node, int delegate(ref K) func) {
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

}






unittest {
    auto tree = new AvlTree!(int)((a, b) => b - a);

    tree.insert(4);
    tree.insert(2);
    tree.insert(8);
    tree.insert(3);
    tree.insert(2);

    writeln(tree);
    writeln(tree.treeroot);

    foreach(t; tree) {
        writeln(t);
    }


    delete tree;

}
