const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

// const data: [16]u8 = [_]u8{ 18, 1, 0, 161, 255, 137, 254, 252, 14, 95, 165, 33, 181, 168, 2, 188 };
const data = "18,1,0,161,255,137,254,252,14,95,165,33,181,168,2,188";
//const data = "1,2,3";

pub fn main() !void {
    var list: [256]u8 = undefined;
    var skip: u8 = 0;
    for (0..256) |i| list[i] = @truncate(i);
    var curr: u8 = 0;
    for (0..64) |_| {
        for (data ++ &[_]u8{17, 31, 73, 47, 23}) |len| {
            var i: u8 = 0;
            while (i < len / 2) : (i += 1) {
                std.mem.swap(u8, &list[curr +% i], &list[curr +% (len - 1 - i)]);
            }
            curr +%= len +% skip;
            skip +%= 1;
        }
    }
    for (0..16) |i| {
        var byte: u8 = 0;
        for (0..16) |j| {
            byte ^= list[i*16 + j];
        }
        print("{x:0>2}", .{byte});
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
