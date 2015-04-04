module erlogtrisy2k.pieceoffsets;

import erlogtrisy2k.block;


import std.stdio;
import std.format;
import std.traits;


struct Point {
    int x, y;
}

struct PieceOffset {
    Point[4] offset;

    Point opIndex(int i) {
        return offset[i];
    }
}


private enum string[PieceType] piecetooffset = [
    PieceType.I : "resources/blocks/i.txt",
    PieceType.L : "resources/blocks/l.txt",
    PieceType.J : "resources/blocks/j.txt",
    PieceType.S : "resources/blocks/s.txt",
    PieceType.Z : "resources/blocks/z.txt",
    PieceType.O : "resources/blocks/o.txt",
    PieceType.T : "resources/blocks/t.txt",
];



private PieceOffset[][PieceType] pieceoffsets;



void loadOffset(PieceType type) {
    File f = File(piecetooffset[type], "r");
    string orientation;

    PieceOffset[] offsets;

    while((orientation = f.readln()) !is null) {
        PieceOffset p;
        formattedRead(orientation, "[%d,%d] [%d,%d] [%d,%d] [%d,%d]", &p.offset[0].x, &p.offset[0].y,
                                                                      &p.offset[1].x, &p.offset[1].y,
                                                                      &p.offset[2].x, &p.offset[2].y,
                                                                      &p.offset[3].x, &p.offset[3].y);
        offsets ~= p;
    }
    pieceoffsets[type] = offsets;
}

PieceOffset[] getOffset(PieceType type) {
    if (!(type in pieceoffsets)) {
        loadOffset(type);
    }
    return pieceoffsets[type];
}

