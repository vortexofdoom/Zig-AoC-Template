const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day08.txt");

const comp = std.math.compare;
const Op = std.math.CompareOperator;

pub fn main() !void {
    var map = StrMap(usize).init(gpa);
    var lines = tokenizeSca(u8, data, '\n');
    var i: usize = 0;
    var reg = List(isize).init(gpa);
    var max: isize = 0;
    while (lines.next()) |line| {
        var parts = tokenizeSca(u8, line, ' ');
        const op_entry = try map.getOrPut(parts.next().?);
        if (!op_entry.found_existing) {
            op_entry.value_ptr.* = i;
            i += 1;
            try reg.append(0);
        }
        const op_reg = op_entry.value_ptr.*;

        const inc = parts.next().?[0] == 'i';
        const op_amt = try parseInt(isize, parts.next().?, 10);
        _ = parts.next();
        const cmp_entry = try map.getOrPut(parts.next().?);
        if (!cmp_entry.found_existing) {
            cmp_entry.value_ptr.* = i;
            i += 1;
            try reg.append(0);
        }
        const cmp_reg = cmp_entry.value_ptr.*;

        const cmp_str = parts.next().?;
        const cmp = switch (cmp_str[0]) {
            '>' => if (cmp_str.len == 1) Op.gt else Op.gte,
            '<' => if (cmp_str.len == 1) Op.lt else Op.lte,
            '!' => Op.neq,
            '=' => Op.eq,
            else => unreachable,
        };
        const cmp_amt = try parseInt(isize, parts.next().?, 10);
        if (comp(reg.items[cmp_reg], cmp, cmp_amt)) {
            reg.items[op_reg] += if (inc) op_amt else -op_amt;
        }
        max = @max(max, sliceMax(isize, reg.items));
    }
    print("{d}\n", .{max});
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
