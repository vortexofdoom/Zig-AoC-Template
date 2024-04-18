const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day24.txt");

const ROWS = 37;
const COLS = 178;
const GOALS = 8;
// const ROWS = 5;
// const COLS = 11;
// const GOALS = 5;
var grid = [_][COLS]bool{[_]bool{false} ** COLS} ** ROWS;
var goals: [GOALS]Coord = undefined;
var start: Coord = undefined;

const Coord = struct {
    r: usize,
    c: usize,

    fn dist(self: Coord, other: Coord) usize {
        return @abs(@as(isize, @bitCast(self.c -% other.c))) + @abs(@as(isize, @bitCast(self.r -% other.r)));
    }

    fn eq(self: Coord, other: Coord) bool {
        return self.r == other.r and self.c == other.c;
    }
};

const Cell = struct {
    coords: Coord,
    g_cost: usize,
};

var res: usize = std.math.maxInt(usize);

fn permute(l: usize, r: usize) !void {
    var prev = start;
    var curr: usize = 0;
    for (goals) |g| {
        const a_star = AStar {
            .start = prev,
            .end = g,
        };
        curr += try a_star.findPath();
        prev = a_star.end;
    }
    res = @min(res, curr);
    if (l != r - 1) {
        for (l..r) |i| {
            std.mem.swap(Coord, &goals[l], &goals[i]);
            try permute(l + 1, r);
            std.mem.swap(Coord, &goals[l], &goals[i]);
        }
    }
}

const AStar = struct {
    start: Coord,
    end: Coord,
    
    fn fCost(self: AStar, cell: Cell) usize {
        return cell.g_cost + self.end.dist(cell.coords);
    }

    fn comp(self: AStar, a: Cell, b: Cell) std.math.Order {
        return switch (std.math.order(self.fCost(a), self.fCost(b))) {
            .eq => std.math.order(self.end.dist(a.coords), self.end.dist(b.coords)),
            else => |ord| ord,
        };
    }

    fn findPath(self: *const AStar) !usize {
        //print("start: ({d}, {d}), end: ({d}, {d})\n", .{self.start.r, self.start.c, self.end.r, self.end.c});
        var q = std.PriorityQueue(Cell, AStar, comp).init(gpa, self.*);
        defer q.deinit();
        var done = Map(Coord, void).init(gpa);
        defer done.deinit();
        try q.add(Cell{.coords = self.start, .g_cost = 0});
        while (q.removeOrNull()) |curr| {
            const entry = try done.getOrPut(curr.coords);
            if (entry.found_existing) continue;
            entry.value_ptr.* = {};
            if (curr.coords.eq(self.end)) return curr.g_cost;
            for (neighbors(curr.coords)) |adj| {
                if (adj) |n| {
                    if (done.contains(n) or !grid[n.r][n.c]) continue;
                    try q.add(Cell{.coords = n, .g_cost = curr.g_cost + 1});
                }
            }
        }
        return std.math.maxInt(usize);
    }
};

fn neighbors(cell: Coord) [4]?Coord {
    const y = cell.r;
    const x = cell.c;
    const u = if (y > 0) Coord{ .r = y - 1, .c = x } else null;
    const r = if (x < COLS - 1) Coord{ .r = y, .c = x + 1 } else null;
    const d = if (y < ROWS - 1) Coord{ .r = y + 1, .c = x } else null;
    const l = if (x > 0) Coord{ .r = y, .c = x - 1 } else null;
    return [_]?Coord{u, r, d, l};
}

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var r: usize = 0;
    var g: usize = 0;
    while (lines.next()) |line| : (r += 1) {
        for (line, 0..) |cell, c| {
            switch (cell) {
                '.' => grid[r][c] = true,
                '0' => {
                    grid[r][c] = true;
                    start = Coord{.r = r, .c = c};

                },
                '1'...'9' => {
                    grid[r][c] = true;
                    goals[g] = Coord{.r = r, .c = c};
                    g += 1;
                },
                else => {}
            }
        }
    }

    goals[GOALS-1] = start;
    try permute(0, GOALS - 1);
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
