const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = "zpqevtbw";
// const data = "abc";

const Check = struct{
    idx: usize,
    digit: u4,
    found: ?usize,

    fn print(self: Check) void {
        std.debug.print("{d}: {x} ({any})\n", .{self.idx, self.digit, self.found});
    }
};

fn check_three() ?u4 {
    var curr: u4 = 0;
    var streak: u8 = 0;
    for (out) |b| {
        for ([_]u4{ @truncate(b >> 4), @truncate(b & 0xF) }) |nib| {
            if (nib == curr) streak += 1 else {
                curr = nib;
                streak = 1;
            }
            if (streak >= 3) return curr;
        }
    }
    return null;
}

fn check_five(n: u8) bool {
    var streak: usize = 0;
    for (out) |b| {
        for ([_]u4{ @truncate(b >> 4), @truncate(b & 0xF) }) |nib| {
            streak = if (nib == n) streak + 1 else 0;
            if (streak >= 5) return true;
        }
    }
    return false;
}

fn lt(_: void, a: usize, b: usize) std.math.Order {
    return std.math.order(a, b);
}

var out: [16]u8 = undefined;

pub fn main() !void {
    const md5 = std.crypto.hash.Md5;
    var i: usize = 0;
    var q = List(Check).init(gpa);
    var found: usize = 0;
    var heap = std.PriorityQueue(usize, void, lt).init(gpa, {});
    var end: usize = std.math.maxInt(usize);
    while (i < end) : (i += 1) {
        var buf = [1]u8{0} ** 256;
        var curr = try std.fmt.bufPrint(&buf, "{s}{d}", .{data, i});
        for (0..2017) |_| {
            md5.hash(curr, &out, .{});
            var j: usize = 0;
            while (j < 16) : (j += 1) {
                _ = try std.fmt.bufPrint(buf[j*2..], "{x:0>2}", .{out[j]});
            }
            curr = buf[0..32];
        }
        if (check_three()) |n| {

            
            const new = Check{
                .digit = n,
                .idx = i,
                .found = null,
            };
            for (q.items) |*chk| {
                if (chk.found) |_| continue;
                if (chk.idx + 1000 >= i and check_five(chk.digit)) {
                    chk.found = i;
                    try heap.add(chk.idx);
                    found += 1;
                    if (found == 64) end = i + 1000;
                }
            }
            try q.append(new);
        }
        while (q.items.len > 0 and q.items[0].idx + 1000 < i) {
            _ = q.orderedRemove(0);
        }
    }
    for (0..64) |j| {
        print("{d}: {d}\n", .{j, heap.remove()});
    }
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
