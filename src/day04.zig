const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var map = StrMap(void).init(gpa);
    var res: usize = 0;
    while (lines.next()) |line| {
        map.clearRetainingCapacity();
        var words = tokenizeSca(u8, line, ' ');
        var found = false;
        while (words.next()) |w| {
            const k = try gpa.dupe(u8, w);
            sort(u8, k, {}, asc(u8));
            const e = try map.getOrPut(k);
            if (e.found_existing) {
                found = true;
                break;
            }

        }
        if (!found) res += 1;
        var iter = map.keyIterator();
        while (iter.next()) |s| {
            gpa.free(s.*);
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
