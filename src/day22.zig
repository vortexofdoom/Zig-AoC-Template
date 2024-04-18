const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Deque = @import("array-deque").ArrayDeque;

const util = @import("util.zig");
const gpa = util.gpa;

const ROWS = 32;
const COLS = 30;
var grid = [_][COLS]Node{[_]Node{Node{}} ** COLS} ** ROWS;

const data = @embedFile("data/day22.txt");

const Node = struct {
    total: usize = 0,
    used: usize = 0,
    avail: usize = 0,

    fn move(self: *Node, other: *Node) bool {
        if (self.used != 0) {
            if (other.avail >= self.used) {
                self.avail += self.used;
                other.used += self.used;
                other.avail -= self.used;
                self.used = 0;
                return true;
            }
        }
        return false;
    }

    fn take(self: *Node, other: *Node, amt: usize) void {
        self.used += amt;
        self.avail -= amt;
        other.used -= amt;
        other.avail += amt;
    }
};

fn neighbors(x: usize, y: usize) [4]?[2]usize {
    const u = if (y > 0) [_]usize{ y - 1, x } else null;
    const r = if (x < COLS - 1) [_]usize{ y, x + 1 } else null;
    const d = if (y < ROWS - 1) [_]usize{ y + 1, x } else null;
    const l = if (x > 0) [_]usize{ y, x - 1 } else null;
    return [_]?[2]usize{ u, r, d, l };
}

fn dfs(r: usize, c: usize) usize {
    //print("{d}, {d}\n", .{c, r});
    if (r == 0 and c == 0) return 0;
    const cell = &grid[r][c];
    const old = cell.used;
    var res: usize = std.math.maxInt(usize);
    for (neighbors(c, r)) |adj| {
        if (adj) |n| {
            const y, const x = n;
            const other = &grid[y][x];
            if (cell.move(other)) {
                res = @min(res, 1 + dfs(y, x));
                cell.take(other, old);
            }
        }
    }
    return res;
}

const State = struct {
    board: [ROWS][COLS]Node,
    curr: [2]usize,
    empty: [2]usize,

    fn moves(self: State) [4]?State {
        const y, const x = self.empty;
        var res: [4]?State = undefined;
        for (neighbors(x, y), 0..) |adj, i| {
            if (adj) |n| {
                var s = self;
                if (!s.board[n[0]][n[1]].move(&s.board[y][x])) {
                    //std.debug.print("can't\n", .{});
                    res[i] = null;
                    continue;
                }
               // std.debug.print("curr: ({d}, {d}), neighbor: ({d}, {d})\n", .{self.curr[0], self.curr[1], n[0], n[1]});
                if (std.mem.eql(usize, &s.curr, &n)) {
                    s.curr = s.empty;
                    std.debug.print("curr changed", .{});
                }
                s.empty = n;
                //s.print();
                res[i] = s;
            } else res[i] = null;
        }
        return res;
    }

    fn print(self: *State) void {
        std.debug.print("curr: ({d}, {d}) empty: ({d}, {d})\n", .{self.curr[0], self.curr[1], self.empty[0], self.empty[1]});
    }
};

fn best(_: void, a: State, b: State) std.math.Order {
    const dist_a = a.curr[0] + a.curr[1];
    const dist_b = a.curr[0] + a.curr[1];
    return switch (std.math.order(dist_a, dist_b)) {
        .eq => std.math.order(
            @abs(@as(isize, @bitCast(a.curr[0] -% a.empty[0]))) + @abs(@as(isize, @bitCast(a.curr[1] -% a.empty[1]))), 
            @abs(@as(isize, @bitCast(b.curr[0] -% b.empty[0]))) + @abs(@as(isize, @bitCast(b.curr[1] -% b.empty[1])))
        ),
        else => |ord| ord,
    };
}

var map = Map(State, usize).init(gpa);

const Queue = std.PriorityQueue(State, void, best);

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    _ = lines.next();
    _ = lines.next();
    while (lines.next()) |line| {
        const y_idx = indexOfStr(u8, line, 0, "-y").?;
        const x = try parseInt(usize, line[16..y_idx], 10);
        const y = try parseInt(usize, trim(u8, line[y_idx + 2 .. 22], " "), 10);
        const total = try parseInt(usize, trim(u8, line[24..27], " "), 10);
        const used = try parseInt(usize, trim(u8, line[30..33], " "), 10);
        const avail = try parseInt(usize, trim(u8, line[37..40], " "), 10);

        grid[y][x] = Node{
            .total = total,
            .used = used,
            .avail = avail,
        };
    }

    for (grid) |row| {
        for (row) |node| {
            print("|{d:>3}/{d:>3}", .{node.used, node.total});
        }
        print("|\n+{s}+\n", .{[_]u8{'-'} ** 239});
    }

    // part 1
    // for (0..32) |r| {
    //     for (0..30) |c| {
    //         const a = grid[r][c];
    //         if (a.used != 0) {
    //             for (0..32) |y| {
    //                 for (0..30) |x| {
    //                     if (!(y == r and x == c)) {
    //                         if (a.used <= grid[y][x].avail) print("a: ({d}, {d}) b: ({d}, {d})\n", .{c, r, x, y});// res += 1;
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }
    // print("{d}\n", .{res});
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
