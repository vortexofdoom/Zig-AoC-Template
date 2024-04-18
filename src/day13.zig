const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Dq = @import("array-deque").ArrayDeque;

const util = @import("util.zig");
const gpa = util.gpa;

const data = 1362;

const Cell = struct {
    x: usize,
    y: usize,

    fn open(self: *const Cell) bool {
        const x = self.x;
        const y = self.y;
        var z = (x * x) + (3 * x) + (2 * x * y) + y + (y * y) + data;
        var count: usize = 0;
        while (z > 0) : (count += 1) z &= z - 1;
        return count & 1 == 0;
    }

    fn neighbors(self: *const Cell) [4]?Cell {
        const x = self.x;
        const y = self.y;
        const u = if (y == 0) null else Cell {.x = x, .y = y - 1};
        const d = if (y == GRID_SIZE - 1) null else Cell {.x = x, .y = y + 1};
        const l = if (x == 0) null else Cell {.x = x - 1, .y = y};
        const r = if (x == GRID_SIZE - 1) null else Cell {.x = x + 1, .y = y};
        return [_]?Cell{ u, d, l, r};
    }
};
const GRID_SIZE = 100;

pub fn main() !void {
    var grid = [_][GRID_SIZE]?bool{[_]?bool{null} ** GRID_SIZE} ** GRID_SIZE;
    var q = Dq(Cell).init(gpa);
    try q.append(Cell{.x = 1, .y = 1});
    // var steps: usize = 0;
    var distinct: usize = 0;
    // while (q.len > 0) : (steps += 1) {
    for (0..50) |_| {
        for (0..q.len) |_| {
            const cell = q.popFront();
            // if (cell.x == 31 and cell.y == 39) {
            //     print("{d}\n", .{steps});
            //     return;
            // }
            for (cell.neighbors()) |adj| {
                if (adj) |n| {
                    const c = n.x;
                    const r = n.y;
                    const g = &grid[r][c];
                    if (g.*) |_| continue;
                    const open = n.open();
                    g.* = open;
                    if (open) {
                        distinct += 1;
                        try q.append(n);
                    }
                }
            }
        }
    }
    print("{d}\n", .{distinct});
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
