const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

var data = @embedFile("data/day04.txt");

fn top_5(counts: []usize) [5]u8 {
    var res = [1]u8{0} ** 5;
    // var curr = [1]usize{0} ** 5;
    for (0..5) |i| {
        var curr: u8 = 'a';
        var count: usize = 0;
        char: for ('a'..'{') |c| {
            for (res[0..i]) |r| if (c == r) continue :char;
            if (counts[c - 'a'] > count) {
                curr = @truncate(c);
                count = counts[c - 'a'];
            }
        }
        res[i] = curr;
    }
    return res;
}

pub fn main() !void {
    var lines = tokenizeSca(u8, data, '\n');
    //var res: usize = 0;
    while (lines.next()) |line| {
        var counts = [1]usize{0} ** 26;
        var parts = tokenizeSca(u8, line, '-');
        while (parts.next()) |part| {
            switch (part[0]) {
                '1'...'9' => {
                    const start = indexOf(u8, part, '[').?;
                    const shift = try parseInt(usize, part[0..start], 10);
                    const chksum = part[start + 1..indexOf(u8, part, ']').?];
                    const t5 = top_5(&counts);
                    var new = try std.fmt.allocPrint(gpa, "{s}\n", .{line});
                    if (std.mem.eql(u8, chksum, &t5)) {
                        for (new[0..]) |*c| {
                            switch (c.*) {
                                '-' => continue,
                                '1'...'9' => break,
                                else => c.* = @truncate((c.* + shift - 'a') % 26 + 'a'),
                            }
                        }
                        if (std.mem.eql(u8, new[0..5], "north")) print("{s}\n", .{new});
                    }
                },
                else => {for (part) |c| counts[c - 'a'] += 1;},
            }
        }
    }
    //print("{d}\n", .{res});
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
