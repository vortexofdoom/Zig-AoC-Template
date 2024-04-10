const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day08.txt");

pub fn main() !void {
    var res: usize = 0;
    var screen = [1]u50{0} ** 6;
    var lines = tokenizeSca(u8, data, '\n');

    while (lines.next()) |line| {
    // for (0..37) |_| {
    //     const line = lines.next().?;
        if (line[1] == 'e') {
            const row: u50 = @as(u50, std.math.maxInt(u50)) << (50 - try parseInt(u6, line[5..lastIndexOf(u8, line, 'x').?], 10));
            for (0..try parseInt(usize, line[line.len - 1..], 10)) |r| {
                screen[r] |= row;
            }
        } else {
            const eq = indexOf(u8, line, '=').?;
            var vars = splitSeq(u8, line[eq+1..], " by ");
            const coord = try parseInt(u6, vars.next().?, 10);
            const amt = try parseInt(u6, vars.next().?, 10);
            if (line[eq-1] == 'x') {
                const bit = @as(u50, 1) << (49 - coord);

                // I'm sure there's a mathematically good way to do this without looping but the numbers are small
                for (0..amt) |_| {
                    const last = screen[5] & bit == 0;
                    var i: usize = 5;
                    while (i > 0) : (i -= 1) {
                        if (screen[i-1] & bit == 0) screen[i] &= ~bit else screen[i] |= bit;
                    }
                    if (last) screen[0] &= ~bit else screen[0] |= bit;
                }
            } else {
                const end = screen[coord] & (@as(u50, std.math.maxInt(u50)) >> (49 - amt));
                screen[coord] >>= amt;
                screen[coord] |= end << (50 - amt);
            }
        }
        for (screen) |r| {
            print("{b:0>50}\n", .{r});
        }
        print("\n", .{});
    }

    for (screen) |r| {
        for (0..50) |i| {
            if (r & (@as(u50, 1) << @truncate(49 - i)) == 0) {
                print(" ", .{});
            } else {
                print("#", .{});
                res += 1;
            }
        }
        print("\n", .{});
        // while (r.* > 0) : (res += 1) {
        //     r.* &= r.* - 1;
        // }
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
