const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day07.txt");

pub fn main() !void {
    var res: usize = 0;
    var lines = tokenizeSca(u8, data, '\n');
    while (lines.next()) |line| {
        var hypernet = false;
        var i: usize = 0;
        // part 1
        // var good = false;
        // var bad = false;
        // while (i < line.len - 3) : (i += 1) {
        // part 2
        var ssl = false;
        var aba_list = List([]const u8).init(gpa);
        while (i < line.len - 2) : (i += 1) {
            // const check = line[i..i+4];
            const check = line[i..i+3];
            if (indexOfAny(u8, check, "[]")) |j| {
                i += j;
                hypernet = !hypernet;
                continue;
            }
            if (check[0] == check[2] and check[0] != check[1] and !hypernet) {
                try aba_list.append(check);
            }
        //     const abba = check[0] == check[3] and check[1] == check[2] and check[0] != check[1];
        //     good = good or (abba and !hypernet);
        //     bad = bad or (abba and hypernet);
        }
        i = 0;
        while (i < line.len - 2 and !ssl) : (i += 1) {
            // const check = line[i..i+4];
            const check = line[i..i+3];
            if (indexOfAny(u8, check, "[]")) |j| {
                i += j;
                hypernet = !hypernet;
                continue;
            }
            if (check[0] == check[2] and check[0] != check[1] and hypernet) {
                for (aba_list.items) |aba| {
                    if (std.mem.eql(u8, aba[0..2], check[1..3])) ssl = true;
                }
            }
        //     const abba = check[0] == check[3] and check[1] == check[2] and check[0] != check[1];
        //     good = good or (abba and !hypernet);
        //     bad = bad or (abba and hypernet);
        }
        if (ssl) res += 1;
        
        // if (good and !bad) res += 1;

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
