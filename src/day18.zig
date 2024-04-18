const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = ".^^^.^.^^^.^.......^^.^^^^.^^^^..^^^^^.^.^^^..^^.^.^^..^.^..^^...^.^^.^^^...^^.^.^^^..^^^^.....^....";
const rows = 400000;
//const data = "..^^.";
//const rows = 3;

pub fn main() !void {
    var a = [_]bool{false} ** data.len;
    var b = [_]bool{false} ** data.len;
    var curr = &a;
    var prev = &b;
    var res: usize = 0;
    for (data, 0..) |by, i| {
        prev[i] = by == '^';
    }
    for (0..rows - 1) |_| {
        for (prev) |t| {
            res += @intFromBool(!t);
            //if (t) print("^", .{}) else print(".", .{});
        }
        //print("\n", .{});
        for (0..data.len) |i| {
            const l = if (i == 0) false else prev[i-1];
            const r = if (i == data.len - 1) false else prev[i+1];
            curr[i] = l != r;
        }
        const temp = curr;
        curr = prev;
        prev = temp;
    }
    // for (prev) |t| {
    //     if (t) print("^", .{}) else print(".", .{});
    // }
    // print("\n", .{});
    //var res: usize = 0;
    for (prev) |t| {if (!t) res += 1;}
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
