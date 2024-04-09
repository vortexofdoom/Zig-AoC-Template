const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var arr: [3][3]usize = undefined;
    var res: usize = 0;
    while (lines.peek()) |_| {
        for (0..3) |r| {
            const line = lines.next().?;
            var nums = tokenizeAny(u8, line, " ");
            for (0..3) |c| {
                arr[c][r] = try parseInt(usize, nums.next().?, 10);
                // part 1
                // if (arr[0] + arr[1] > arr[2]) res += 1;
            }
        }
        for (0..3) |tri| {
            sort(usize, &arr[tri], {}, asc(usize));
            if (arr[tri][0] + arr[tri][1] > arr[tri][2]) res += 1;
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
