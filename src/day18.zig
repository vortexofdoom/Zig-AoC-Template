const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day18.txt");

var board: [100][100]u8 = undefined;

const NEIGHBORS = [8][2]isize{
    [2]isize{-1, -1},
    [2]isize{-1, 0},
    [2]isize{-1, 1},
    [2]isize{0, -1},
    [2]isize{0, 1},
    [2]isize{1, -1},
    [2]isize{1, 0},
    [2]isize{1, 1},
};

fn neighbors(row: usize, col: usize) usize {
    var res: usize = 0;
    for (NEIGHBORS) |n| {
        const r = @as(isize, @bitCast(row)) + n[0];
        const c = @as(isize, @bitCast(col)) + n[1];
        if (
            r < 0 or 
            r > 99 or 
            c < 0 or 
            c > 99
        ) continue;
        res += board[@as(usize, @bitCast(r))][@as(usize, @bitCast(c))] & 1;
    }
    return res;
}

var curr: isize = 0;

fn step() void {
    curr = 0;
    board[0][0] = 3;
    board[0][99] = 3;
    board[99][0] = 3;
    board[99][99] = 3;
    for (0..100) |r| {
        for (0..100) |c| {
            const count = neighbors(r, c);
            if (count == 2) board[r][c] *= 3;
            if (count == 3) board[r][c] |= 2;
        }
    }
    for (0..100) |r| {
        for (0..100) |c| {
            board[r][c] >>= 1;
            curr += board[r][c];
        }
    }
}

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var r: usize = 0;
    while (lines.next()) |l| : (r += 1) {
        for (0..100) |c| {
            board[r][c] = if (l[c] == '#') 1 else 0;
        }
    }

    for (0..100) |_| step();
    print("{d}\n", .{curr});
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
