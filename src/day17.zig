const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Md5 = std.crypto.hash.Md5;

const util = @import("util.zig");
const gpa = util.gpa;

//const data = "ihgpwlah";
const data = "hhhxzeay";

var out: [16]u8 = undefined;
var buf = [_]u8{0} ** 2048;
var res: ?[]const u8 = null;

fn checkPath(hash: []const u8) [4]bool {
    const u: u4 = @truncate(hash[0] >> 4);
    const d: u4 = @truncate(hash[0] & 0xF);
    const l: u4 = @truncate(hash[1] >> 4);
    const r: u4 = @truncate(hash[1] & 0xF);
    return [_]bool{ ok(u), ok(d), ok(l), ok(r) };
}

fn ok(char: u4) bool {
    return char == 0xb or char == 0xc or char == 0xd or char == 0xe or char == 0xf;
}

fn getCell(curr: u4, dir: u8) ?u4 {
    switch (dir) {
        'U' => return if (curr > 3) curr - 4 else null,
        'D' => return if (curr < 12) curr + 4 else null,
        'L' => return if (curr & 3 != 0) curr - 1 else null,
        'R' => return if (curr & 3 != 3) curr + 1 else null,
        else => unreachable
    }
}

fn dfs(curr: u4, path: *List(u8)) !void {
    if (curr == 15) {
        if (res) |r| {
            // if (r.len > path.items.len) {
            if (r.len < path.items.len) {
                gpa.free(r);
                res = try std.fmt.allocPrint(gpa, "{s}", .{path.items});
            } else return;
        } else res = try std.fmt.allocPrint(gpa, "{s}", .{path.items});
        return;
    }
    Md5.hash(try std.fmt.bufPrint(&buf, "{s}{s}", .{data, path.items}), &out, .{});
    for (checkPath(&out), "UDLR") |open, dir| {
        if (open) {
            try path.append(dir);
            if (getCell(curr, dir)) |c| try dfs(c, path);
            _ = path.pop();
        }
    }
}

pub fn main() !void {
    var path = List(u8).init(gpa);
    try dfs(0, &path);
    //print("{s}\n", .{res.?});
    print("{d}\n", .{res.?.len});
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
