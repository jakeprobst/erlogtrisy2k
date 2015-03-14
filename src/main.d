import erlogtrisy2k.erlogtrisy2k;

import std.stdio;
import std.traits;

import erlogtrisy2k.messagebus;
import std.algorithm;
import std.random;

import erlogtrisy2k.sortedlist;



void main()
{
    ErlogTrisY2K erlogtrisy2k = new ErlogTrisY2K();
    erlogtrisy2k.run();
    delete erlogtrisy2k;


    /*bool cmpint(int a, int b) {
        return a > b;
    }

    auto list = new SortedList!(int)(&cmpint);

    foreach(i; 1..15) {
        list.insert(uniform(1,20));
    }


    writeln("list: ", list);
    writeln("length: ", list.data.length);
    foreach(l; list) {
        writeln(l);
    }

    writeln("list: ", list);*/

}
