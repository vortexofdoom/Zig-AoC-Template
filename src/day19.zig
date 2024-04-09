const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;
const data = @embedFile("data/day19.txt");

//const m: []const u8 = "CRnCaSiRnBSiRnFArTiBPTiTiBFArPBCaSiThSiRnTiBPBPMgArCaSiRnTiMgArCaSiThCaSiRnFArRnSiRnFArTiTiBFArCaCaSiRnSiThCaCaSiRnMgArFYSiRnFYCaFArSiThCaSiThPBPTiMgArCaPRnSiAlArPBCaCaSiRnFYSiThCaRnFArArCaCaSiRnPBSiRnFArMgYCaCaCaCaSiThCaCaSiAlArCaCaSiRnPBSiAlArBCaCaCaCaSiThCaPBSiThPBPBCaSiRnFYFArSiThCaSiRnFArBCaCaSiRnFYFArSiThCaPBSiThCaSiRnPMgArRnFArPTiBCaPRnFArCaCaCaCaSiRnCaCaSiRnFYFArFArBCaSiThFArThSiThSiRnTiRnPMgArFArCaSiThCaPBCaSiRnBFArCaCaPRnCaCaPMgArSiRnFYFArCaSiThRnPBPMgAr";

const Dp = struct {
    earliest: usize,
    res: usize,
};

var keys: [43][]const u8 = [1][]const u8{ "" } ** 43;

var map: StrMap([]const u8) = undefined;
var molecules: StrMap(usize) = undefined;
var dp: StrMap(Dp) = undefined;

const eq = std.mem.eql;

fn dfs(curr: []const u8, steps: usize) !usize {
    if (eq(u8, curr, "HF") or eq(u8, curr, "NAl") or eq(u8, curr, "OMg")) {
        print("{s}: {d}\n", .{curr, steps + 1});
        return steps + 1;
    }
    if (curr.len <= 3) return std.math.maxInt(usize);
    const entry = try dp.getOrPut(curr);
    if (entry.found_existing) {
        gpa.free(curr);
        if (entry.value_ptr.res != std.math.maxInt(usize) and entry.value_ptr.earliest > steps) {
            const diff = entry.value_ptr.earliest - steps;
            entry.value_ptr.res -= diff;
            entry.value_ptr.earliest = steps;
        }
        return entry.value_ptr.res;
    } else {
        entry.value_ptr.* = Dp {
            .earliest = steps,
            .res = std.math.maxInt(usize),
        };
    }

    // entry.value_ptr.*.res = std.math.maxInt(usize);
    for (keys) |k| {
        if (lastIndexOfStr(u8, curr, k)) |start| {
            // print("{s}: {d}\n", .{k, steps});
            const v: []const u8 = map.get(k).?;
            const end = if (start + k.len < curr.len) curr[start+k.len..] else "";
            const new = try std.fmt.allocPrint(
                gpa, 
                "{s}{s}{s}", 
                .{curr[0..start], v, end }
            );
            entry.value_ptr.res = @min(try dfs(new, steps + 1), entry.value_ptr.res);
        }
    }
    return entry.value_ptr.res;
}

fn countStr(h: []const u8, s: []const u8) usize {
    var m = h[0..];
    var res: usize = 0;
    while (std.mem.indexOfPos(u8, m, 0, s)) |i| {
        m = m[i + s.len..];
        res += 1;
    }
    return res;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    // var map = StrMap(List([]const u8)).init(alloc);
    map = StrMap([]const u8).init(alloc);
    dp = StrMap(Dp).init(alloc);
    // var distinct = StrMap(void).init(alloc);
    // var res: usize = 0;
    // opts = StrMap(usize).init(gpa);
    var k: usize = 0;
    var lines = splitSca(u8, data, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) break;
        var split = tokenizeSeq(u8, line, " => ");
        const val = split.next().?;
        // const entry = try map.getOrPutValue(split.next().?, val);
        const key = split.next().?;
        keys[k] = key;
        k += 1;
        try map.put(key, val);
        // if (!entry.found_existing) entry.value_ptr.* = List([]const u8).init(alloc);
        // try entry.value_ptr.append(split.next().?);
    }

    sort([]const u8, keys[0..], .{}, lenSort);

    //const m = lines.next().?;
    const m = "HOH";
    var upper: usize = 0;
    // while (iter.next()) |_| upper += 1;
    for (m) |c| { if (std.ascii.isUpper(c)) upper += 1; }
    // const ar = countStr(m, "Ar");
    // const rn = countStr(m, "Ar");
    // const y = countStr(m, "Y");
    // print("{d} {d} {d}\n", .{ar, rn, y});
    print("{d}\n", .{upper - countStr(m, "Rn") - countStr(m, "Ar") - (2 * countStr(m, "Y")) - 1});

    // for (0..molecule.len) |i| {
    //     var list: ?[][]const u8 = null;
    //     var rest: ?usize = null;
    //     if (map.get(molecule[i..i+1])) |l| {
    //         list = l.items;
    //         if (i < molecule.len - 2) rest = i + 1;
    //     }
    //     if (i < molecule.len - 1) {
    //         if (map.get(molecule[i..i+2])) |l| {
    //             list = l.items;
    //             if (i < molecule.len - 3) rest = i + 2;
    //         }
    //     }
        

    //     var start: usize = i;
    //     if (list) |l| {
    //         for (l) |s| {
    //             for (s, 0..) |r, j| {
    //                 if (i+j >= molecule.len or r != molecule[i+j]) {
    //                     start = i + j;
    //                     const str_entry = try distinct.getOrPut(try std.fmt.allocPrint(alloc, "{s}{s}{s}", .{molecule[0..start], s[j..], molecule[rest.?..]}));
    //                     if (!str_entry.found_existing) res += 1;
    //                     break;
    //                 }
    //             }
    //         }
    //     }
    // }

    // const m = try std.fmt.allocPrint(gpa, "{s}", .{molecule});
    // try opts.put(m, 0);
    // var q = Deque([]const u8).init(gpa);
    // var stack = List([]const u8).init(gpa);
    // try stack.append(m);
    // try q.append(molecule);
    //print("{d}\n", .{q.len});

    //print("{d}\n", .{try dfs(m, 0)});
    // while (stack.items.len > 0) {
    //     const curr = stack.pop();
    //     if (curr.len < 20) print("{s}\n", .{curr});
    //     // defer gpa.free(curr);
    //     const step: usize = opts.get(curr).?;
    //     var found: bool = undefined;
    //     for (0..curr.len) |i| {
    //         found = false;
    //         var replacements = map.iterator();
    //         while (replacements.next()) |e| {
    //             if (found) break;
    //             const k = e.key_ptr.*;
    //             const end = i + k.len;
    //             if (end <= curr.len and std.mem.eql(u8, k, curr[i..end])) {
    //                 found = true;
    //                 var start: usize = i;
    //                 const s = e.value_ptr.*;
    //                 for (s, 0..) |r, j| {
    //                     if (i+j >= curr.len or r != curr[i+j]) {
    //                         start = i + j;
    //                         const new = try std.fmt.allocPrint(
    //                             gpa, 
    //                             "{s}{s}{s}", 
    //                             .{curr[0..start], s[j..], if (start + s.len - j < curr.len) curr[end..] else "" }
    //                         );
    //                         const entry = try opts.getOrPut(new);
    //                         if (entry.found_existing)  {
    //                             entry.value_ptr.* = @min(entry.value_ptr.*, step);
    //                             gpa.free(new);
    //                             continue;
    //                         }
    //                         if (std.mem.eql(u8, new, "e")) {
    //                             print("{d}\n", .{step + 1});
    //                             return;
    //                         }
    //                         try opts.put(new, step + 1);
    //                         //print("{s}\n", .{new});

    //                         try stack.append(new);
    //                         // print("{d}\n", .{q.len});
    //                     }
    //                 }
    //             }
    //         }
    //         // for (i + 1..@min(curr.len, i+11)) |end| {
    //         //     if (map.get(curr[i..end])) |s| {
    //         //         found = true;
    //         //         //print("{s}: {s}\n", .{curr[i..end], s});
    //         //         var start: usize = i;
    //         //         for (s, 0..) |r, j| {
    //         //             if (i+j >= curr.len or r != curr[i+j]) {
    //         //                 start = i + j;
    //         //                 const new = try std.fmt.allocPrint(
    //         //                     gpa, 
    //         //                     "{s}{s}{s}", 
    //         //                     .{curr[0..start], s[j..], if (start + s.len - j < curr.len) curr[end..] else "" }
    //         //                 );
    //         //                 if (opts.get(new)) |_| {
    //         //                     gpa.free(new);
    //         //                     continue;
    //         //                 }
    //         //                 if (std.mem.eql(u8, new, "e")) {
    //         //                     print("{d}\n", .{step + 1});
    //         //                     return;
    //         //                 }
    //         //                 try opts.put(new, step + 1);
    //         //                 //print("{s}\n", .{new});

    //         //                 try stack.append(new);
    //         //                 // print("{d}\n", .{q.len});
    //         //             }
    //         //         }
    //         //     }
    //         // }
    //     }
    // }

    //print("{d}\n", .{res});
}

fn lenSort(_: @TypeOf(.{}), lhs: []const u8, rhs: []const u8) bool {
    return lhs.len > rhs.len;
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
