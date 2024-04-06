const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day06.txt");

pub fn main() !void {
    var grid: [1000][1000]usize = [1][1000]usize{[1]usize{0} ** 1000} ** 1000;
    var i: usize = 0;
    var count: usize = 0;
    while (i < data.len) : (i += 1) {
        // determine whether toggle/on/off by looking at the 7th character
        const action_end = data[i + 6];
        // advance to the start of the first coordinate
        switch (data[i+6]) {
            ' ' => i += 7,
            'n' => i += 8,
            'f' => i += 9,
            else => unreachable,
        }

        // parse first x
        var num_start = i;
        while (data[i] >= '0' and data[i] <= '9') : (i += 1) {}
        const x1 = try parseInt(usize, data[num_start..i], 10);
        i += 1;

        // parse first y
        num_start = i;
        while (data[i] >= '0' and data[i] <= '9') : (i += 1) {}
        const y1 = try parseInt(usize, data[num_start..i], 10);

        // advance to the start of the 2nd coordinate
        i += 9;

        // parse 2nd x
        num_start = i;
        while (data[i] >= '0' and data[i] <= '9') : (i += 1) {}
        const x2 = try parseInt(usize, data[num_start..i], 10);
        i += 1;

        // parse 2nd y
        num_start = i;
        while (data[i] >= '0' and data[i] <= '9') : (i += 1) {}
        const y2 = try parseInt(usize, data[num_start..i], 10);

        for (x1..x2 + 1) |y| {
            for (y1..y2 + 1) |x| {
                switch (action_end) {
                    ' ' => {
                        grid[x][y] += 2;
                        count += 2;
                    },

                    'n' => {
                        grid[x][y] += 1;
                        count += 1;
                    },

                    'f' => if (grid[x][y] > 0) {
                        grid[x][y] -= 1;
                        count -= 1;
                    },

                    else => unreachable,
                }
                
            }
        }
        print("{}\n", .{count});
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
