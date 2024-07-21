const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = "ffayrhll";
//const data = "18,1,0,161,255,137,254,252,14,95,165,33,181,168,2,188";

const UnionFind = struct {
    parent: [128 * 128]usize = undefined,
    rank: [128 * 128]usize = [_]usize{0} ** (128 * 128),

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

pub fn hash(str: []const u8) u128 {
    var list: [256]u8 = undefined;
    var skip: u8 = 0;
    for (0..256) |i| list[i] = @truncate(i);
    var curr: u8 = 0;
    for (0..64) |_| {
        for (str) |len| {
            var i: u8 = 0;
            while (i < len / 2) : (i += 1) {
                std.mem.swap(u8, &list[curr +% i], &list[curr +% (len - 1 - i)]);
            }
            curr +%= len +% skip;
            skip +%= 1;
        }
    }
    var res: u128 = 0;
    for (0..16) |i| {
        var byte: u8 = 0;
        for (0..16) |j| {
            byte ^= list[i * 16 + j];
        }
        //print("{x:0>2}", .{byte});
        res <<= 8;
        res |= byte;
    }
    //print("\n{x:0>16}\n", .{res});
    return res;
}

pub fn main() !void {
    var grid: [128]u128 = undefined;
    var buf: [256]u8 = undefined;
    _ = hash(data ++ &[_]u8{ 17, 31, 73, 47, 23 });
    for (0..128) |i| {
        const str = try std.fmt.bufPrint(&buf, "{s}-{d}" ++ &[_]u8{ 17, 31, 73, 47, 23 }, .{ data, i });
        grid[i] = hash(str);
    }

    var uf = UnionFind{};
    for (0..(128 * 128)) |i| uf.parent[i] = i;

    const one: u128 = 1;
    for (0..128) |i| {
        for (0..128) |j| {
            if ((grid[i] & (one << @truncate(j))) != 0) {
                if (i > 0 and (grid[i - 1] & (one << @truncate(j))) != 0) uf.unite((i * 128) + (127 - j), (i - 1) * 128 + (127 - j));
                if (i < 127 and (grid[i + 1] & (one << @truncate(j))) != 0) uf.unite((i * 128) + (127 - j), (i + 1) * 128 + (127 - j));
                if (j > 0 and (grid[i] & (one << @truncate(j - 1))) != 0) uf.unite((i * 128) + (127 - j), (i * 128) + (127 - (j - 1)));
                if (j < 127 and (grid[i] & (one << @truncate(j + 1))) != 0) uf.unite((i * 128) + (127 - j), (i * 128) + (127 - (j + 1)));
            }
        }
    }

    var map = Map(usize, void).init(gpa);
    var res: usize = 0;
    for (0..128) |i| {
        for (0..128) |j| {
            if ((grid[i] & (one << @truncate(j))) != 0) {
                // res += 1;
                const entry = try map.getOrPut(uf.find((128 * i) + (127 - j)));
                if (!entry.found_existing) res += 1;
            }
        }
    }

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
