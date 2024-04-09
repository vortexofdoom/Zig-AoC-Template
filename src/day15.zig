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

fn score() isize {
    var cap: isize = 0;
    var dur: isize = 0;
    var fla: isize = 0;
    var tex: isize = 0;
    var cal: isize = 0;

    for (ingredients, cookie) |i, c| {
        cap += i.cap * @as(isize, c);
        dur += i.dur * @as(isize, c);
        fla += i.fla * @as(isize, c);
        tex += i.tex * @as(isize, c);
        cal += i.cal * @as(isize, c);
    }
    if (cal != 500) return 0;
    return @max(0, cap) * @max(0, dur) * @max(0, fla) * @max(0, tex);
}

var cookie = [4]u16{0, 0, 0, 0};

pub fn main() !void {
    var res: isize = 0;
    for (0..100) |sp| {
        for (0..100-sp + 1) |bs| {
            for (0..100 - (bs + sp) + 1) |ch| {
                for (0..100-(bs+sp+ch)+1) |ca| {
                    cookie[0] = @truncate(sp);
                    cookie[1] = @truncate(bs);
                    cookie[2] = @truncate(ch);
                    cookie[3] = @truncate(ca);

                    if (sp + bs + ch + ca == 100) res = @max(res, score());
                }
            }
        }
    }
    print("{d}\n", .{res});
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
