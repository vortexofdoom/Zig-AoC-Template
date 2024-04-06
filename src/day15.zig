const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day15.txt");

const Ingredient = struct {
    cap: isize,
    dur: isize,
    fla: isize,
    tex: isize,
    cal: isize,
};

const ingredients = [4]Ingredient{
    sprinkles,
    butterscotch,
    chocolate,
    candy,  
};

const sprinkles = Ingredient{
    .cap = 2,
    .dur = 0,
    .fla = -2,
    .tex = 0,
    .cal = 3,
};

const butterscotch = Ingredient{
    .cap = 0,
    .dur = 5,
    .fla = -3,
    .tex = 0,
    .cal = 3,
};

const chocolate = Ingredient{
    .cap = 0,
    .dur = 0,
    .fla = 5,
    .tex = -1,
    .cal = 8,
};

const candy = Ingredient{
    .cap = 0,
    .dur = -1,
    .fla = 0,
    .tex = 5,
    .cal = 8,
};

fn score() usize {
    var cap: isize = 0;
    var dur: isize = 0;
    var fla: isize = 0;
    var tex: isize = 0;
    var cal: isize = 0;
    cal = 0;

    for (ingredients, cookie) |i, c| {
        cap += i.cap * c;
        dur += i.dur * c;
        fla += i.fla * c;
        tex += i.tex * c;
    }
    
    return @max(0, cap * dur * fla * tex);
}

var cookie = [4]isize{0, 0, 0, 0};

pub fn main() !void {
    
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
