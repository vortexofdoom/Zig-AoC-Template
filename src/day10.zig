const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day10.txt");

const Give = union(enum) {
    output: usize,
    bot: usize,

    fn new(str: []const u8) !Give {
        var parts = tokenizeSca(u8, str, ' ');
        const kind = parts.next().?;
        const val = try parseInt(usize, parts.next().?, 10);
        return switch (kind[0]) {
            'b' => Give{.bot = val},
            else => Give{.output = val},
        };
    }
};

const Bot = struct {
    get: [2]?usize,
    lo: ?Give,
    hi: ?Give,

    fn new() Bot {
        return Bot {
            .get = [2]?usize{null, null},
            .lo = null,
            .hi = null,
        };
    }

    fn add(self: *Bot, val: usize) void {
        if (self.get[0]) |v| {
            if (val < v) {
                self.get[1] = v;
                self.get[0] = val; 
            } else if (val > v) {
                self.get[1] = val;
            } 
        } else self.get[0] = val;
    }
};

const lo_split = " gives low to ";
const hi_split = " and high to ";

pub fn main() !void {
    var bots: [210]Bot = [_]Bot{Bot.new()} ** 210;
    var output = [_]usize{0} ** 21;
    var lines = tokenizeSca(u8, data, '\n');
    while (lines.next()) |line| {
        if (line[0] == 'b') {
            var parts = splitSeq(u8, line[4..], lo_split);
            const bot = try parseInt(usize, parts.next().?, 10);
            var gives = splitSeq(u8, parts.next().?, hi_split);
            const lo = try Give.new(gives.next().?);
            const hi = try Give.new(gives.next().?);

            bots[bot].lo = lo;
            bots[bot].hi = hi;
        } else {
            var parts = splitSeq(u8, line[6..], " goes to bot ");
            const val = try parseInt(usize, parts.next().?, 10);
            const bot = try parseInt(usize, parts.next().?, 10);
            bots[bot].add(val);
        }
    }
    var init = false;
    var res: usize = undefined;
    while (!init) {
        init = true;
        for (&bots, 0..) |*bot, i| {
            if (bot.get[0]) |get_lo| {
                if (bot.get[1]) |get_hi| {
                    if (get_lo == 17 and get_hi == 61) res = i;
                    if (bot.lo) |lo| switch (lo) {
                        .bot => |b| bots[b].add(get_lo),
                        .output => |o| output[o] = get_lo,
                    } else init = false;
                    if (bot.hi) |hi| switch (hi) {
                        .bot => |b| bots[b].add(get_hi),
                        .output => |o| output[o] = get_hi,
                    } else init = false;
                } else init = false;
            } else init = false;
        }
    }
    print("{d}\n", .{res});
    print("{d}\n", .{output[0] * output[1] * output[2]});
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
