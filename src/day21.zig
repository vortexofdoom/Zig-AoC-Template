const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day21.txt");
var orig = [_]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' };
//var input = [_]u8{ 'b', 'a', 'd', 'c', 'h', 'f', 'g', 'e' };
//var input = [_]u8{ 'a', 'b', 'c', 'd', 'e' };

const Rotate = union(enum) {
    letter: u8,
    amount: u8,
};

const Op = union(enum) {
    rot: Rotate,
    rev: [2]usize,
    mov: [2]usize,
};

// fn rotate(str: []const u8) !void {
//     const i = indexOf(u8, str, ' ').? + 1;
//     if (str[0] != 'p') {
//         //var first: usize = 0;
//         var amt: u3 = undefined;
//         switch (str[0]) {
//             'b' => {
//                 const j = indexOf(u8, &input, str[str.len - 1]).?;
//                 //first = input.len - 1;
//                 const change = j + @intFromBool(j >= 4);
//                 amt = @truncate(input.len - 1 -% change);// else (input.len + change) % input.len;
//             },
//             'l' => amt = try parseInt(u3, str[i..i+1], 10),
//             'r' => amt = @truncate(input.len - try parseInt(usize, str[i..i+1], 10)),
//             else => unreachable
//         }
//         //ops[o] = .{.rot = [_]usize{ first, amt }};
//         std.mem.rotate(u8, &input, amt);
//     } else {
//         var tokens = tokenizeSca(u8, str, ' ');
//         _ = tokens.next();
//         const start = try parseInt(usize, tokens.next().?, 10);
//         _ = tokens.next();
//         const end = try parseInt(usize, tokens.next().?, 10);
//         std.mem.reverse(u8, input[start..end + 1]);
//     }
// }

fn permute(l: usize, r: usize) !void {
    try run();
    if (l != r) {
        for (l..r+1) |i| {
            std.mem.swap(u8, &orig[l], &orig[i]);
            try permute(l + 1, r);
            std.mem.swap(u8, &orig[l], &orig[i]);
        }
    }
}

fn run() !void {
    var input = orig;
    var lines = tokenizeSca(u8, data, '\n');
    //var ops: [100]Op = undefined;
    var o: usize = 0;
    while (lines.next()) |line| : (o += 1) {
    //print("{s}\n", .{line});
        const idx = indexOf(u8, line, ' ').?;
        const rest = line[idx+1..];
        switch (line[0]) {
            'r' => {
                const i = indexOf(u8, rest, ' ').? + 1;
                if (rest[0] != 'p') {
                    //var first: usize = 0;
                    var amt: u3 = undefined;
                    switch (rest[0]) {
                        'b' => {
                            const j = indexOf(u8, &input, rest[rest.len - 1]).?;
                            //first = input.len - 1;
                            const change = j + @intFromBool(j >= 4);
                            amt = @truncate(input.len - 1 -% change);// else (input.len + change) % input.len;
                        },
                        'l' => amt = try parseInt(u3, rest[i..i+1], 10),
                        'r' => amt = @truncate(input.len - try parseInt(usize, rest[i..i+1], 10)),
                        else => unreachable
                    }
                    //ops[o] = .{.rot = [_]usize{ first, amt }};
                    std.mem.rotate(u8, &input, amt);
                } else {
                    var tokens = tokenizeSca(u8, rest, ' ');
                    _ = tokens.next();
                    const start = try parseInt(usize, tokens.next().?, 10);
                    _ = tokens.next();
                    const end = try parseInt(usize, tokens.next().?, 10);
                    std.mem.reverse(u8, input[start..end + 1]);
                }
            },
            'm' => {
               //print("{s}\n", .{line});
               //print("{s}\n", .{input});
                var tokens = tokenizeSca(u8, rest, ' ');
                _ = tokens.next();
                const start = try parseInt(usize, tokens.next().?, 10);
                _ = tokens.next();
                _ = tokens.next();
                const end = try parseInt(usize, tokens.next().?, 10);
                const char = input[start];
                if (end > start) {
                    //print("bck\n", .{});
                    std.mem.copyForwards(u8, input[start..end], input[start+1..end+1]);
                } else {
                    //print("fwd\n", .{});
                    std.mem.copyBackwards(u8, input[end+1..start+1], input[end..start]);
                }
                input[end] = char;
                //print("{s}\n", .{input});
            },
            's' => {
                var tokens = tokenizeSca(u8, rest, ' ');
                const pos = tokens.next().?[0] == 'p';
                const a = tokens.next().?;
                //print("{s}\n", .{a});
                const start = if (pos) try parseInt(usize, a, 10) else indexOf(u8, &input, a[0]).?;
                _ = tokens.next();
                _ = tokens.next();
                const b = tokens.next().?;
                const end = if (pos) try parseInt(usize, b, 10) else indexOf(u8, &input, b[0]).?;
                std.mem.swap(u8, &input[start], &input[end]);
            },
            else => unreachable
        }
        //print("{s}\n", .{input});
    }
    if (std.mem.eql(u8, &input, "fbgdceah")) print("{s}\n", .{orig});
}

pub fn main() !void {
    try permute(0, 7);
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
