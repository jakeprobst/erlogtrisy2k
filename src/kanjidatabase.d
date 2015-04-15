module erlogtrisy2k.kanjidatabase;


import erlogtrisy2k.avltree;

import std.stdio;
import std.file;
import std.string;
import std.utf;
import std.algorithm;
import erlogtrisy2k.memory;

enum ListType {
    Grade,
    JLPT,
    Heisig
}

alias KanjiList = AvlTree!(wchar, void*, (a, b) => b - a);
alias WordList = AvlTree!(wstring, wstring, (a,b) => cmp(b, a));



class KanjiDatabase {
    KanjiList kanjilist;
    WordList wordlist;

    this(ListType type, int level)  {
        kanjilist = make!KanjiList();
        wordlist = make!WordList();
        if (type == ListType.Grade) {
            wstring kanjis = readText(format("resources/japanese/grade%d.txt", level)).toUTF16();
            foreach(c; kanjis) {
                kanjilist.insert(c, null);
            }

            auto edict = File("resources/japanese/edict.utf8","r");
  dictloop: foreach(line; edict.byLine) {
                auto splitline = line.toUTF16.splitter;
                wstring word = splitline.front();
                splitline.popFront();
                
                foreach(c; word) {
                    if (!kanjilist.exists(c)) {
                        continue dictloop;
                    }
                }

                wstring def = splitline.join(" ");

                wordlist.insert(word, def);
            }
        }
        else if (type == ListType.JLPT) {
        }
        else if (type == ListType.Heisig) {
        }
    }
    ~this() {
        unmake(kanjilist);
        unmake(wordlist);
    }


    /*wchar getCharacter() {
    }

    bool isWord(wstring str) {
    }*/


}



unittest {
    KanjiDatabase kanjidb = make!KanjiDatabase(ListType.Grade, 1);

    unmake(kanjidb);
}





