const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day12.txt");

fn bracket_end(start: u8, str: []const u8) usize {
    const end: u8 = if (start == '{') '}' else ']';
    var cnt: usize = 1;
    for (str, 0..) |c, i| {
        if (c == start) cnt += 1;
        if (c == end) cnt -= 1;
        if (cnt == 0) return i;
    }
    return 0;
}

fn sum_json(json: []const u8, object: bool) !i64 {
    var res: i64 = 0;
    var i: usize = 0;
    while (i < json.len) : (i += 1) {
        switch (json[i]) {
            '{' => {
                const end = bracket_end(json[i], json[i+1..]);
                res += try sum_json(json[i+1..i+1+end], true);
                i += 1 + end;
            },
            '[' => {
                const end = bracket_end(json[i], json[i+1..]);
                res += try sum_json(json[i+1..i+1+end], false);
                i += 1 + end;
            },
            // ':' => continue,
            ':' => if (object and json.len - i >= 6 and std.mem.eql(u8, json[i+1..i+6], "\"red\"")) return 0,
            ' ', '\n', ',' => continue,
            '\"' => {
                while (i < json.len - 1 and json[i+1] != '\"') : (i += 1) {}
                i += 1;
            },
            else => {
                var j = i + 1;
                while (j < json.len and std.ascii.isDigit(json[j])) : (j += 1) {}
                res += try parseInt(i64, json[i..j], 10);
                i = j;
            }
        }
    }
    return res;
}

pub fn main() !void {
    print("{d}\n", .{try sum_json(data[0..], false)});
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
