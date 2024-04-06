const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day08.txt");

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var res: usize = 0;
    while (lines.next()) |line| {
        // res += line.len;
        // var i: usize = 1;
        // while (i < line.len - 1) : (i += 1) {
        //     if (line[i] == '\\') {
        //         i += switch (line[i+1]) {
        //             '\\', '\"' => 1,
        //             else => 3,
        //         };
        //     }
        //     res -= 1;   
        // }
        res += 2;
        for (0..line.len) |i| {
            res += switch (line[i]) {
                '\\', '\"' => 2,
                else => 1,
            };
        }
        res -= line.len;
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
