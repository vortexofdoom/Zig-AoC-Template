const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day12.txt");

const UnionFind = struct {
    parent: [2000]usize = undefined,
    rank: [2000]usize = [_]usize{0} ** 2000,

    fn find(self: *UnionFind, i: usize) usize {
        if (self.parent[i] != i) {
            self.parent[i] = self.find(self.parent[i]);
        }
        return self.parent[i];
    }

    fn unite(self: *UnionFind, a: usize, b: usize) void {
        const a_set = self.find(a);
        const b_set = self.find(b);

        if (a_set == b_set) return;

        switch (std.math.order(self.rank[a_set], self.rank[b_set])) {
            .lt => self.parent[a_set] = b_set,
            .gt => self.parent[b_set] = a_set,
            .eq => {
                self.parent[b_set] = a_set;
                self.rank[a_set] += 1;
            },
        }
    }
};

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var uf = UnionFind{};
    for (0..2000) |i| {
        uf.parent[i] = i;
    }

    while (lines.next()) |line| {
        var iter = splitSeq(u8, line, " <-> ");
        const a = try parseInt(usize, iter.next().?, 10);
        var rest = tokenizeSeq(u8, iter.next().?, ", ");
        while (rest.next()) |c| {
            const b = try parseInt(usize, c, 10);
            uf.unite(a, b);
        }
    }

    var map = Map(usize, void).init(gpa);
    var res: usize = 0;
    for (0..2000) |i| {
        try map.put(uf.find(i), {});
        if (uf.find(0) == uf.find(i)) res += 1;
    }

    print("{d}\n", .{res});
    print("{d}\n", .{map.count()});
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
