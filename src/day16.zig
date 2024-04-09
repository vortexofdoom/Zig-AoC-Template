const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day16.txt");

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    outer: while (lines.next()) |line| {
        const split = indexOf(u8, line, ':').?;
        const sue = line[4..split];
        var items = tokenizeSeq(u8, line[split+2..], ", ");
        while (items.next()) |item| {
            var entry = tokenizeSeq(u8, item, ": ");
            const k = entry.next().?[0..3];
            const v = try parseInt(u8, entry.next().?, 10);
            //print("{s}: {d}\n", .{k, v});
            if (eql(u8, k, "chi") and v != 3) continue :outer;
            // if (eql(u8, k, "cat") and v != 7) continue :outer;
            if (eql(u8, k, "cat") and v <= 7) continue :outer;
            if (eql(u8, k, "car") and v != 2) continue :outer;
            if (eql(u8, k, "sam") and v != 2) continue :outer;
            // if (eql(u8, k, "pom") and v != 3) continue :outer;
            if (eql(u8, k, "pom") and v >= 3) continue :outer;
            if (eql(u8, k, "aki") and v != 0) continue :outer;
            if (eql(u8, k, "viz") and v != 0) continue :outer;
            // if (eql(u8, k, "gol") and v != 5) continue :outer;
            if (eql(u8, k, "gol") and v >= 5) continue :outer;
            if (eql(u8, k, "per") and v != 1) continue :outer;
            // if (eql(u8, k, "tre") and v != 3) continue :outer;
            if (eql(u8, k, "tre") and v <= 3) continue :outer;
        }
        print("{s}\n", .{sue});
    }
}

// Useful stdlib functions
const eql = std.mem.eql;
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
