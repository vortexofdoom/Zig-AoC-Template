const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

// const data = @embedFile("data/day09.txt");
const data = "X(8x2)(3x3)ABCY";

fn dfs(curr: []const u8) !u128 {
    var res: u128 = 0;
    var i: usize = 0;
    while (i < curr.len) : (i += 1) {
         if (curr[i] == '(') {
            const x = indexOfStr(u8, curr, i, "x").?;
            const chars = try parseInt(usize, curr[i+1..x], 10);
            const end = indexOfStr(u8, curr, x, ")").?;
            const n = try parseInt(usize, curr[x+1..end], 10);
            res += n * try dfs(curr[end+1..end+1+chars]);
            i = end + chars;
        } 
    }
    return res;
}

pub fn main() !void {
    print("{d}\n", .{try dfs(data)});
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
