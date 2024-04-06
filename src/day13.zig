const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day13.txt");
var rng: std.rand.Xoshiro256 = undefined;
var change: [9][9]i64 = [1][9]i64{[9]i64{0, 0, 0, 0, 0, 0, 0, 0, 0}} ** 9;
var layout = [9]u8{0, 1, 2, 3, 4, 5, 6, 7, 8};

fn happiness() i64 {
    var res: i64 = 0;
    for (layout[0..], 0..) |p, seat| {
        const l = if (seat == 0) layout[8] else layout[seat - 1];
        const r = if (seat == 8) layout[0] else layout[seat + 1];
        res += change[p][l] + change[p][r];
    }
    return res;
}

pub fn main() !void {
    rng = std.rand.DefaultPrng.init(@bitCast(std.time.timestamp()));
    var lines = tokenizeSeq(u8, data, ".\n");
    for (0..8) |p1| {
        for (0..8) |p2| {
            if (p1 == p2) continue;
            var tkns = tokenizeSeq(u8, lines.next().?, " happiness units by sitting next to ");
            const diff = tkns.next().?;
            const i = lastIndexOf(u8, diff, ' ').?;
            change[p1][p2] = try parseInt(i64, diff[i+1..], 10);
            if (diff[i-4] == 'l') change[p1][p2] *= -1;  
        }
    }

    var res: i64 = 0;

    for (0..100000) |_| {
        const p1 = rng.random().int(u3);
        const p2 = rng.random().int(u3);
        const temp = layout[p1];
        layout[p1] = layout[p2];
        layout[p2] = temp;
        res = @max(res, happiness());
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
