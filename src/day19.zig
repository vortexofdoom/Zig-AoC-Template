const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Deque = @import("array-deque").ArrayDeque;

const util = @import("util.zig");
const gpa = util.gpa;

const data = 3005290;
//const data = 5;

pub fn main() !void {
    var l = try Deque(usize).initCapacity(gpa, data);
    var r = try Deque(usize).initCapacity(gpa, data);
    //var q = try List(usize).initCapacity(gpa, data + 1);
    defer l.deinit();
    defer r.deinit();
    for (1..data / 2 + 1) |i| {
        try l.append(i);
    }
    for (data / 2 + 1..data + 1) |i| {
        try r.prepend(i);
    }
    while (l.len() > 0 and r.len() > 0) {
        _ = if (l.len() > r.len()) l.popBack() else r.popBack();
        try r.prepend(l.popFront());
        try l.append(r.popBack());
        //print("{any}\n", .{q.items});
    }
    const res = if (l.len() > 0) l.get(0).* else r.get(0).*;
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
