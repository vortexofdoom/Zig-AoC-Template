const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = "ojvtpuvg";

pub fn main() !void {
    var buf = [1]u8{0} ** 256;
    var out: [16]u8 = undefined;
    var res: [8]u8 = undefined;
    var init: u8 = 0;
    var i: usize = 0;
    while (init != 255) {
        while (!(out[0] == 0 and out[1] == 0 and out[2] & 0xF0 == 0)) : (i += 1)
            std.crypto.hash.Md5.hash(try std.fmt.bufPrint(&buf, "{s}{d}", .{data, i}), &out, .{});
        const j: u8 = out[2] & 0x0F;
        if (j < 8) {
            const bit: u8 = @as(u8, 1) << @truncate(j);
            if (init & bit == 0) {
                init |= bit;
                res[j] = out[3] >> 4;}
            }
        i += 1;
        std.crypto.hash.Md5.hash(try std.fmt.bufPrint(&buf, "{s}{d}", .{data, i}), &out, .{});
    }
    for (res) |c| {
        print("{x}", .{c});
    }
    print("\n", .{});
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
