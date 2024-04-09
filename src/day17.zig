const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

var data = [_]u8{11, 30, 47, 31, 32, 36, 3, 1, 5, 3, 32, 36, 15, 11, 46, 26, 28, 1, 19, 3};

var min: u8 = 20;
var curr: u8 = 0;

fn dfs(i: u8, remaining: u8) usize {
    if (remaining == 0) {
        min = @min(min, curr);
        return if (curr > min) return 0 else 1;
    }
    if (i == 20) return 0;
    var use: usize = undefined;
    if (data[i] > remaining) use = 0 else {
        curr += 1;
        use = dfs(i+1, remaining - data[i]);
        curr -= 1;
    }

    return use + dfs(i+1, remaining);
}

pub fn main() !void {
    const d = desc(u8);
    sort(u8, data[0..], {}, d);
    _ = dfs(0, 150);
    print("{any}\n", .{dfs(0, 150)});
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
