const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

const Dir = enum {
    N,
    E,
    S,
    W,

    fn turn(self: *Dir, d: u8) void {
        self.* = switch (self.*) {
            .N => if (d == 'L') Dir.W else Dir.E,
            .E => if (d == 'L') Dir.N else Dir.S,
            .S => if (d == 'L') Dir.E else Dir.W,
            .W => if (d == 'L') Dir.S else Dir.N,
        };
    }
};

const GRID_OFFSET = 256;
const GRID_SIZE = 512;
var visited: [GRID_SIZE][GRID_SIZE]bool = [1][GRID_SIZE]bool{[1]bool{false} ** GRID_SIZE} ** GRID_SIZE;

pub fn main() !void {
    var ew: isize = 0;
    var ns: isize = 0;
    var map = Map(struct {isize, isize}, void).init(gpa);
    try map.put(.{0, 0}, {});
    var dir = Dir.N;
    var tokens = tokenizeSeq(u8, trim(u8, data, "\n"), ", ");
    outer: while (tokens.next()) |t| {
        print("N: {d}, E: {d}\n", .{ns, ew});
        const walk = try parseInt(u32, t[1..], 10);
        print("{d}\n", .{walk});
        dir.turn(t[0]);
        switch (dir) {
            .N => {
                const c: usize = @bitCast(ew + GRID_OFFSET);
                var r: usize = @bitCast(ns + GRID_OFFSET);
                const end = r + walk;
                while (r < end) : ({r += 1; ns += 1;}) {
                    if (visited[r][c]) break: outer else visited[r][c] = true;
                }
            },
            .E => {
                const r: usize = @bitCast(ns + GRID_OFFSET);
                var c: usize = @bitCast(ew + GRID_OFFSET);
                const end = c + walk;
                while (c < end) : ({c += 1; ew += 1;}) {
                    if (visited[r][c]) break: outer else visited[r][c] = true;
                }
            },
            .S => {
                const c: usize = @bitCast(ew + GRID_OFFSET);
                var r: usize = @bitCast(ns + GRID_OFFSET);
                const end = r - walk;
                while (r > end) : ({r -= 1; ns -= 1;}){
                    if (visited[r][c]) break: outer else visited[r][c] = true;
                }
            },
            .W => {
                const r: usize = @bitCast(ns + GRID_OFFSET);
                var c: usize = @bitCast(ew + GRID_OFFSET);
                const end = c - walk;
                while (c > end) : ({c -= 1; ew -= 1;}){
                    if (visited[r][c]) break: outer else visited[r][c] = true;
                }
            }
        }
        const entry = try map.getOrPut(.{ns, ew});
        if (entry.found_existing) {
            print("Found\n", .{});
            break;
        }
    }
    print("N: {d}, E: {d}\n", .{ns, ew});
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
