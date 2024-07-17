const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var res: usize = 0;
    while (lines.next()) |line| {
        var max: usize = 0;
        var min: usize = std.math.maxInt(usize);
        var numstrs = tokenizeSca(u8, line, '\t');
        var nums = [_]usize{0} ** 16;
        var i: usize = 0;
        loop: while (numstrs.next()) |num| : (i += 1) {
            const n = try parseInt(usize, num, 10);
            for (nums[0..i]) |x| {
                if (x % n == 0) {
                    res += x / n;
                    break :loop;
                } else if (n % x == 0) {
                    res += n / x;
                    break :loop;
                }
            }
            nums[i] = n;
            // print("{s}\n", .{num});
            max = @max(max, n);
            min = @min(min, n);
        }
        // res += max - min;
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
