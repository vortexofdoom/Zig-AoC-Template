const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day09.txt");

const Dist = struct {
    city_a: usize,
    city_b: usize,
    dist: usize,
};

var indices: StrMap(usize) = undefined;
var index: usize = 0;

fn get_idx(str: []const u8) !usize {
    const entry = try indices.getOrPut(str[0..2]);
    if (!entry.found_existing) {
        entry.value_ptr.* = index;
        index += 1;
    }
    return entry.value_ptr.*;
}

var matrix: [8][8]usize = undefined;

fn perms(curr: u3, visited: u8) usize {
    // var res: usize = std.math.maxInt(u64);
    // if (visited == 255) return 0;
    var res: usize = 0;
    inline for (0..8) |i| {
        const bit = 1 << i;
        if (visited & bit == 0) {
            // res = @min(res, matrix[curr][i] + perms(i, visited | bit));
            res = @max(res, matrix[curr][i] + perms(i, visited | bit));
        }
    }
    return res;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    indices = StrMap(usize).init(alloc);
    var list = List(Dist).init(alloc);
    var lines = tokenizeSca(u8, data, '\n');
    while (lines.next()) |line| {
        var split = splitSeq(u8, line, " = ");
        var cities = splitSeq(u8, split.next().?, " to ");
        const city_a = try get_idx(cities.next().?);
        const city_b = try get_idx(cities.next().?);
        
        try list.append(Dist{
            .city_a = city_a,
            .city_b = city_b,
            .dist = try parseInt(usize, split.next().?, 10),
        });
    }

    for (list.items) |path| {
        const a = path.city_a;
        const b = path.city_b;
        const d = path.dist;
        matrix[a][a] = 0;
        matrix[b][b] = 0;
        matrix[a][b] = d;
        matrix[b][a] = d;
    }

    // var res: usize = std.math.maxInt(u64);
    var res: usize = 0;
    inline for (0..8) |start| {
        // res = @min(res, perms(@truncate(start), 1 << start));
        res = @max(res, perms(@truncate(start), 1 << start));
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
