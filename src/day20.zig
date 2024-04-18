const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day20.txt");

const Range = struct {
    start: usize,
    end: usize,
};

fn lt(_: void, l: Range, r: Range) bool {
    return l.start < r.start or (l.start == r.start and l.end < r.end);
}

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var res: usize = 0;
    var ranges: [1005]Range = undefined;
    for (&ranges) |*r| {
    // while (lines.next()) |line| {
        var parts = tokenizeSca(u8, lines.next().?, '-');
        r.* = Range{
            .start = try parseInt(usize, parts.next().?, 10),
            .end = try parseInt(usize, parts.next().?, 10),
        };      
    }
    sort(Range, &ranges, {}, lt);
    var curr = ranges[0];
    for (ranges[1..]) |r| {
        if (r.start > curr.end + 1) {
            res += r.start - (curr.end + 1);
            curr = r;
        }
        curr.end = @max(curr.end, r.end);
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
