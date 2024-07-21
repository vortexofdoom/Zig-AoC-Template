const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day09.txt");

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    const input = lines.next().?;
    var i: usize = 0;
    var garbage = false;
    var curr_score: usize = 0;
    var total_score: usize = 0;
    var non_canceled: usize = 0;
    while (i < input.len) : (i += 1) {
        if (garbage) non_canceled += 1;
        switch (input[i]) {
            '!' => {
                i += 1;
                if (garbage) non_canceled -= 1;
            },
            '<' => garbage = true,
            '>' => {
                garbage = false;
                non_canceled -= 1;
            },
            '{' => if (!garbage) { curr_score += 1; },
            '}' => if (!garbage) {
                total_score += curr_score;
                curr_score -= 1;
            },
            else => {}
        }
    }
    print("{d}\n", .{total_score});
    print("{d}\n", .{non_canceled});
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
