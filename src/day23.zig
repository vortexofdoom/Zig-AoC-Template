const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day23.txt");

const Jump = struct {
    reg: *isize,
    offset: isize,
};

const Inst = union(enum) {
    hlf: *isize,
    tpl: *isize,
    inc: *isize,
    jmp: isize,
    jie: Jump,
    jio: Jump,
};



pub fn main() !void {
    var prog: [49]Inst = undefined;
    var lines = tokenizeSca(u8, data, '\n');
    var i: isize = 0;
    var a: isize = 1;
    var b: isize = 0;
    while (lines.next()) |l| : (i += 1) {
        if (l[2] == 'p') {
            prog[@bitCast(i)] = Inst{ .jmp = try parseInt(isize, l[4..], 10) - 1 };
            continue;
        }
        const reg = if (l[4] == 'a') &a else &b;
        switch (l[2]) {
            'f' => prog[@bitCast(i)] = Inst{ .hlf = reg },
            'l' => prog[@bitCast(i)] = Inst{ .tpl = reg },
            'c' => prog[@bitCast(i)] = Inst{ .inc = reg },
            'e' => prog[@bitCast(i)] = Inst{ .jie = Jump{ .reg = reg, .offset = try parseInt(u8, l[7..], 10) - 1 } },
            'o' => prog[@bitCast(i)] = Inst{ .jio = Jump{ .reg = reg, .offset = try parseInt(u8, l[7..], 10) - 1 } },
            else => unreachable,
        }
    }
    i = 0;
    while (i < 49) : (i += 1) {
        switch (prog[@bitCast(i)]) {
            .hlf => |r| r.* = @divExact(r.*, 2),
            .tpl => |r| r.* *= 3,
            .inc => |r| r.* += 1,
            .jmp => |o| i += o,
            .jie => |j| {
                if (j.reg.* & 1 == 0) i += j.offset;
            },
            .jio => |j| {
                if (j.reg.* == 1) i += j.offset;
            }
        }
    }

    print("{d}\n", .{b});
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
