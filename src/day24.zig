const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

var data = [_]usize{1,2,3,7,11,13,17,19,23,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113};

var min_count: usize = std.math.maxInt(usize);
var res: u256 = std.math.maxInt(u256);

const Group = struct {
    count: usize,
    sum: usize,
    product: u256,

    fn new() Group {
        return Group{
            .count = 0,
            .sum = 0,
            .product = 1,
        };
    }

    fn add(self: Group, n: usize) Group {
        // print("count: {d}, sum: {d}, product: {d}\n", .{self.count, self.sum, self.product});
        return Group{
            .count = self.count + 1,
            .sum = self.sum + n,
            .product = self.product * n,
        };
    }

    fn lt(_: void, lhs: Group, rhs: Group) bool {
        return lhs.count < rhs.count or (lhs.count == rhs.count and lhs.product < rhs.product);
    }

    fn min(a: Group, b: Group, c: Group) Group {
        if (a.lt(b) and a.lt(c)) return a;
        if (b.lt(a) and b.lt(c)) return b;
        return c;
    }
};

const bad = std.math.maxInt(u256);

var dp: Map(Dp, u256) = undefined;

const Dp = struct { usize, Group, Group, Group, Group };

fn dfs(i: usize, groups: []Group) !u256 {
    sort(Group, groups, {}, Group.lt);
    const a = groups[0];
    const b = groups[1];
    const c = groups[2];
    const d = groups[3];
    const entry = try dp.getOrPut(Dp{i, a, b, c, d});
    if (a.count > 4 or a.sum > 390 or b.sum > 390 or c.sum > 390 or d.sum > 390) {
        //entry.value_ptr.* = bad;
        return bad;
    }
    if (entry.found_existing) {
        return entry.value_ptr.*;
    }
    if (i == data.len) {
        if (a.sum == b.sum and b.sum == c.sum and c.sum == d.sum) {
            print("a: {d} ({d}), b: {d} ({d}), c: {d} ({d}), d: {d} ({d})\n", .{a.count, a.product, b.count, b.product, c.count, c.product, d.count, d.product});
            if (a.count < min_count) {
                min_count = a.count;
                res = a.product;
            } else if (a.count == min_count) {
                res = @min(res, a.product);
            }
            entry.value_ptr.* = res;
            return res;
        } else return bad;
    }
    const n = data[i];
    groups[0] = a.add(n);
    res = @min(res, try dfs(i+1, groups));
    groups[0] = a;
    groups[1] = b.add(n);
    groups[2] = c;
    groups[3] = d;
    res = @min(res, try dfs(i+1, groups));
    groups[0] = a;
    groups[1] = b;
    groups[2] = c.add(n);
    groups[3] = d;
    res = @min(res, try dfs(i+1, groups));
    groups[0] = a;
    groups[1] = b;
    groups[2] = c;
    groups[3] = d.add(n);
    res = @min(res, try dfs(i+1, groups));
    entry.value_ptr.* = res;
    return res;
}

pub fn main() !void {
    //const d = desc(usize);
    sort(usize, &data, {}, desc(usize));
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    dp = Map(Dp, u256).init(alloc);
    // var sum: usize = 0;
    // for (data) |n| sum += n;
    // print("{d}\n", .{sum/4});
    var groups = [4]Group{Group.new(), Group.new(), Group.new(), Group.new()};
    _ = try dfs(0, &groups);
    groups[3] = Group.new();
    print("{d}\n", .{try dfs(0, &groups)});
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
