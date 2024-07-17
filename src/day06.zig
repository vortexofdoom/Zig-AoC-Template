const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const SLOTS: usize = 16;

const data = @embedFile("data/day06.txt");

pub fn main() !void {
    var lines = tokenizeAny(u8, data, "\t\n");
    var i: u4 = 0;
    var bank: [SLOTS]usize = undefined;
    while (lines.next()) |line| : (i +%= 1) {
        bank[i] = try parseInt(usize, line, 10);
    }
    var map = Map([SLOTS]usize, usize).init(gpa);
    var cycles: usize = 0;
    while (true) : (cycles += 1) {
        i = 0;
        const e = try map.getOrPut(bank);
        if (e.found_existing) {
            print("{d}\n", .{cycles - e.value_ptr.*});
            break;
        }
        e.value_ptr.* = cycles;
        for (bank, 0..) |b, j| {
            if (b > bank[i]) i = @truncate(j);
        }
        var curr = bank[i];
        bank[i] = 0;
        i +%= 1;
        while (curr > 0) : ({i +%= 1; curr -= 1;}) {
            bank[i] += 1;
        }
    }

    print("{d}\n", .{cycles});
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
