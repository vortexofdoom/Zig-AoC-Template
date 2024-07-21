const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Queue = std.PriorityQueue;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day11.txt");

const Move = enum {
    n,
    ne,
    nw,
    se,
    sw,
    s,
};

const Hex = struct {
    q: isize = 0,
    r: isize = 0,
    s: isize = 0,

    fn eq(self: *const Hex, other: Hex) bool {
        return self.q == other.q and self.r == other.r and self.s == other.s;
    }

    fn diff(self: *const Hex, other: Hex) u64 {
        return @abs(self.q - other.q) + @abs(self.r - other.r) + @abs(self.s - other.s);
    }

    fn move(self: *const Hex, dir: Move) Hex {
        return switch (dir) {
            .n => Hex{
                .q = self.q,
                .r = self.r - 1,
                .s = self.s + 1,
            },
            .ne => Hex{
                .q = self.q + 1,
                .r = self.r - 1,
                .s = self.s,
            },
            .nw => Hex{
                .q = self.q - 1,
                .r = self.r,
                .s = self.s + 1,
            },
            .se => Hex{
                .q = self.q + 1,
                .r = self.r,
                .s = self.s - 1,
            },
            .sw => Hex{
                .q = self.q - 1,
                .r = self.r + 1,
                .s = self.s,
            },
            .s => Hex{
                .q = self.q,
                .r = self.r + 1,
                .s = self.s - 1,
            },
        };
    }
};

fn comp(context: Hex, a: Hex, b: Hex) std.math.Order {
    if (a.eq(b)) return .eq;
    return if (a.diff(context) < b.diff(context)) .lt else .gt;
}

pub fn main() !void {
    var directions = tokenizeSca(u8, data, ',');
    const start = Hex{};
    var curr = start;
    var max_dist: u64 = 0;
    //var map = Map(Hex, void).init(gpa);
    while (directions.next()) |dir| {
        const move = if (dir[0] == 'n') ifblk: {
            if (dir.len == 1) break :ifblk Move.n else {
                break :ifblk if (dir[1] == 'e') Move.ne else Move.nw;
            }
        } else elseblk: {
            if (dir.len == 1) break :elseblk Move.s else {
                break :elseblk if (dir[1] == 'e') Move.se else Move.sw;
            }
        };
        curr = curr.move(move);
        const dist = start.diff(curr) / 2;
        max_dist = @max(max_dist, dist);
    }
    // const end = curr;
    // var q = Queue(Hex, Hex, comp).init(gpa, end);
    // try q.add(start);
    // var moves: usize = 0;
    // while (q.items.len > 0) : (moves += 1) outer: {
    //     var new_q = List(Hex).init(gpa);
    //     for (q.items) |h| {
    //         if (h.eq(end)) break :outer;
    //         try map.put(h, {});
    //         for ([_]Move{ .n, .ne, .nw, .se, .sw, .s }) |dir| {
    //             const n = h.move(dir);
    //             if (!map.contains(n)) try new_q.append(n);
    //         }
    //     }
    //     q.deinit();
    //     q = new_q;
    // }
    print("{d}\n", .{start.diff(curr) / 2});
    print("{d}\n", .{max_dist});
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
