const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day14.txt");

const Reindeer = struct {
    speed: isize,
    dur: isize,
    wait: isize,
    cycle: usize,
    go: bool,
};

var deer: [9]Reindeer = undefined;
var dist: [9]isize = [1]isize{0} ** 9;
var score: [9]isize = [1]isize{0} ** 9;

pub fn main() !void {
    var lines = tokenizeSeq(u8, data, " seconds.\n");
    var i: usize = 0;
    while (lines.next()) |line| : (i += 1) {
        var split = splitSeq(u8, line, " seconds, but then must rest for ");
        const start = split.next().?;
        var parts = splitSeq(u8, start, " km/s for ");
        const speed_str = parts.next().?;
        const s = lastIndexOf(u8, speed_str, ' ').? + 1;
        print("{s}\n", .{speed_str[s..]});
        const speed = try parseInt(isize, speed_str[s..], 10);
        const dur = try parseInt(isize, parts.next().?, 10);
        const wait = try parseInt(isize, split.next().?, 10);
        deer[i] = Reindeer{
            .speed = speed,
            .dur = dur,
            .wait = wait,
            .go = true,
            .cycle = 0,
        };
    }

    var t: usize = 0;
    while (t < 2503) : (t += 1) {
        for (deer[0..9], 0..) |*r, j| {
            r.cycle += 1;
            if (r.go) {
                dist[j] += r.speed;
                if (r.cycle == r.dur) {
                    r.go = false;
                    r.cycle = 0;
                }
            } else {
                if (r.cycle == r.wait) {
                    r.go = true;
                    r.cycle = 0;
                }
            }
        }
        score[indexOf(isize, dist[0..], sliceMax(isize, dist[0..])).?] += 1; 
    }

    print("{d}\n", .{sliceMax(isize, score[0..])});
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
