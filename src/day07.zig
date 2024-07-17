const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day07.txt");

const Node = struct {
    name: []const u8,
    children: List(*Node),
    weight: usize = 0,
    weight_above: ?usize = null,
    parent: ?*Node = null,

    fn weightAbove(self: *Node) usize {
        if (self.weight_above) |w| return w;
        var res: usize = 0;
        for (self.children.items) |c| {
            res += c.weight + c.weightAbove();
        }
        self.weight_above = res;
        return res;
    }

    fn totalWeight(self: *Node) usize {
        return self.weightAbove() + self.weight;
    }

    fn cmp(self: *Node, other: *Node) std.math.Order {
        return std.math.order(self.totalWeight(), other.totalWeight());
    }
};

fn lt(_: void, l: *Node, r: *Node) bool {
    return l.cmp(r) == .lt;
}

fn dfs(node: *Node) ?usize {
    const children = node.children.items;
    sort(*Node, children, {}, lt);
    if (children.len == 2) {
        for (children) |child| if (dfs(child)) |n| return n;
        return null;
    } else if (children.len > 2) {
        const l = children[0];
        const r = children[children.len - 1];
        if (l.cmp(r) == .eq) return null;
        const diff = if (l.cmp(children[1]) == .eq) r else l;
        return if (dfs(diff)) |n| n else diff.weight +% (children[1].totalWeight() -% diff.totalWeight());
    } else return null;
}

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var map = StrMap(Node).init(gpa);
    try map.ensureTotalCapacity(1500);
    while (lines.next()) |line| {
        const i = indexOf(u8, line, ' ').?;
        const name = line[0..i];
        var rest = tokenizeAny(u8, line[i..], "() ->,");
        const weight = try parseInt(usize, rest.next().?, 10);
        const entry = try map.getOrPut(name);
        if (!entry.found_existing) entry.value_ptr.* = Node{ .name = name, .children = List(*Node).init(gpa) };
        entry.value_ptr.weight = weight;
        while (rest.next()) |n| {
            const child = try map.getOrPut(n);
            if (!child.found_existing) child.value_ptr.* = Node { .name = n, .children = List(*Node).init(gpa) };
            child.value_ptr.parent = entry.value_ptr;
            try entry.value_ptr.children.append(child.value_ptr);
        }
    }
    var iter = map.iterator();
    var node = iter.next().?.value_ptr;
    node = iter.next().?.value_ptr;
    while (node.parent) |p| node = p;
    print("{s}\n", .{node.name});
    print("{d}\n", .{dfs(node).?});
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
