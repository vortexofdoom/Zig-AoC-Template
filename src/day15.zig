const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day15.txt");
//const count = [_]usize { 5, 2 };
//var curr = [_]usize { 4, 1 };
 const count = [_]usize{13, 19, 3, 7, 5, 17, 11};
 var curr = [_]usize{1, 10, 2, 1, 3, 5, 0};

pub fn main() !void {
    for (&curr, 0..) |*d, i| {
        d.* = (d.* + i + 1) % count[i];
    }
    var i: usize = 0;
    var again = true;
    while (again) : ({
        i += 1;
    }) {
        again = false;
        for (curr) |d| {if (d != 0) again = true;}
        for (&curr, 0..) |*d, j| {
            d.* = (d.* + 1) % count[j];
        }
    }
    print("{d}\n", .{i - 1});
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
