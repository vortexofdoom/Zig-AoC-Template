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
    var b: u4 = 5;
    while (lines.next()) |line| {
        for (line) |c| {
            switch (c) {
                'U' => {
                    // part 1
                    // if (b > 3) b -= 3;
                    // part 2
                    switch (b) {
                        0x3, 0xD => b -= 2,
                        0x6...0x8, 0xA...0xC => b -= 4,
                        else => {}
                    }
                },
                'R' => {
                    // part 1
                    // if (b % 3 != 0) b += 1;
                    // part 2
                    switch (b) {
                        2, 3, 5...8, 0xA, 0xB => b += 1,
                        else => {}
                    }
                },
                'D' => {
                    // part 1
                    // if (b < 7) b += 3;
                    // part 2
                    switch (b) {
                        0x1, 0xB => b += 2,
                        0x2...0x4, 0x6...0x8 => b += 4,
                        else => {}
                    }
                },
                'L' => {
                    // part 1
                    // if (b % 3 != 1) b -= 1;
                    // part 2
                    switch (b) {
                        3, 4, 6...9, 0xB, 0xC => b -= 1,
                        else => {}
                    }
                },
                else => unreachable
            }
        }
        print("{x}", .{b});
    }
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
