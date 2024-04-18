const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = "10111100110001111";
// const disk = 272;
const disk = 35651584;
//const data = "10000";
//const disk = 20;

pub fn main() !void {
    // var res = [_]u1{0} ** disk;
    var res = try gpa.alloc(u1, disk);
    for (data, 0..) |b, i| res[i] = @truncate(b - '0');
    var i: usize = data.len;
    var j: usize = i;
    while (i < disk) : (i += 1) {
        res[i] = if (j == i) 0 else ~res[j];
        j = if (j == 0) i + 1 else j - 1;
    }
    j = disk;
    while (j & 1 == 0) {
        j = j / 2;
        i = 0;
        while (i < j) : (i += 1) {
            res[i] = @intFromBool(res[i*2] == res[i*2+1]);
        }
    }
    for (res[0..j]) |b| {
        print("{d}", .{b});
    }
    print("\n", .{});
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
