const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day23.txt");

const Args = struct {
    l: Either,
    r: Either,
};


const Either = union(enum) {
    reg: *isize,
    val: isize,
};

const Inst = union(enum) {
    cpy: Args,
    inc: *isize,
    dec: *isize,
    jnz: Args,
    tgl: *isize,
};

pub fn main() !void {
    var prog: [26]Inst = undefined;
    var lines = tokenizeSca(u8, data, '\n');
    var i: isize = 0;
    var regs = [_]isize{0} ** 4;
    while (lines.next()) |l| : (i += 1) {
        var tokens = tokenizeSca(u8, l, ' ');
        const inst = tokens.next().?;
        const next = tokens.next().?;
        const arg1 = if (parseInt(isize, next, 10)) |n| Either{ .val = n } else |_| Either{ .reg = &regs[next[0]-'a']};
        const arg2 = tokens.next();
        prog[@bitCast(i)] = switch (inst[0]) {
            'c' => Inst{.cpy = Args{.l = arg1, .r = Either{ .reg = &regs[l[l.len - 1]-'a']}}},
            'j' => Inst{.jnz = Args{.l = arg1, .r = if (parseInt(isize, arg2.?, 10)) |j| Either{ .val = j } else |_| Either{.reg = &regs[arg2.?[0]-'a']}}},
            'i' => Inst{.inc = arg1.reg},
            'd' => Inst{.dec = arg1.reg},
            't' => Inst{.tgl = arg1.reg},
            else => unreachable
        };
    }
    regs[0] = 12;
    i = 0;
    while (i < 26) : (i += 1) {
        switch (prog[@bitCast(i)]) {
            .inc => |r| r.* += 1,
            .dec => |r| r.* -= 1,
            .cpy => |c| if (c.r == .reg) {
                    c.r.reg.* = switch (c.l) {
                    .reg => |r| r.*,
                    .val => |v| v,
                };
            },
            .jnz => |j| {
                const v = switch (j.l) {
                    .reg => |r| r.*,
                    .val => |v| v,
                };
                if (v != 0) i += switch (j.r) {
                    .val => |n| n - 1,
                    .reg => |r| r.* - 1,
                };
            },
            .tgl => |r| {
                const j: usize = @bitCast(i + r.*);
                if (j < 26) {
                    prog[j] = switch (prog[j]) {
                        .inc => |a| Inst{.dec = a},
                        .dec, .tgl => |a| Inst{.inc = a},
                        .jnz => |a| Inst{.cpy = a},
                        .cpy => |a| Inst{.jnz = a},
                    };
                }
            }
        }
    }

    print("{d}\n", .{regs[0]});
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
