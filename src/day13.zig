const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day13.txt");

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    var firewall = [_]usize{0} ** 93;
    // var scanner = [_]usize{0} ** 93;
    while (lines.next()) |line| {
        var iter = splitSeq(u8, line, ": ");
        firewall[try parseInt(usize, iter.next().?, 10)] = try parseInt(usize, iter.next().?, 10);
    }
    // var severity: isize = 1;
    var caught = true;
    var delay: usize = 0;
    while (caught) : (delay += 1) {
        caught = false;
        for (0..93) |i| {
            if (firewall[i] > 0 and ((delay + i) % (2 * (firewall[i] - 1)) == 0)) {
                caught = true;
                break;
            }
        }
    }
    // for (0..93) |packet| {
    //     if (firewall[packet] != 0 and scanner[packet] == 0) severity += @as(isize, @bitCast(packet)) * firewall[packet];
    //     for (0..93) |i| {
    //         if (scanner[i] == firewall[i] - 1) {
    //             scanner[i] = -scanner[i];
    //         }
    //         scanner[i] += 1;
    //     }
    // }
    // print("{d}\n", .{severity});
    print("{d}\n", .{delay});
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
