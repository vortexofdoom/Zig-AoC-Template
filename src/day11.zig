const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

var data = [8]u8{'v', 'z', 'b', 'x', 'k', 'g', 'h', 'b'};

fn validate(pw: [8]u8) bool {
    var run = false;
    var pair1: ? usize = null;
    var pair2 = false;
    for (0..8) |i| {
        switch (pw[i]) {
            'i', 'o', 'l' => return false,
            else => {
                if (i < 6 and pw[i+1] == pw[i] + 1 and pw[i+2] == pw[i] + 2) run = true;
                if (i < 7 and pw[i] == pw[i+1]) {
                    if (pair1) |p1| {
                        pair2 = i > (p1 + 1);
                    } else pair1 = i;
                } 
            }
        }
    }
    return run and pair2;
}

fn next() void {
    if (data[7] != 'z') {
        data[7] += 1;
    } else {
        var i: usize = 7;
        while (data[i] == 'z') : (i -= 1) {
            data[i] = 'a';
        }
        data[i] += 1;
    }
}

pub fn main() !void {
    while (!validate(data)) : (next()) {}
    next();
    while (!validate(data)) : (next()) {}
    print("{s}\n", .{data});
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
