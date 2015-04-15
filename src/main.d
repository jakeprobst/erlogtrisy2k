import erlogtrisy2k.erlogtrisy2k;
import erlogtrisy2k.avltree;
import erlogtrisy2k.memory;

import std.stdio;

void main()
{
    /*ErlogTrisY2K erlogtrisy2k = new ErlogTrisY2K();
    erlogtrisy2k.run();
    delete erlogtrisy2k;*/

    ErlogTrisY2K erlogtrisy2k = make!ErlogTrisY2K();
    erlogtrisy2k.run();
    unmake(erlogtrisy2k);
}
