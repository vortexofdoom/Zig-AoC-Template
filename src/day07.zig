const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day07.txt");

var map: StrMap(?Register) = undefined;

const Input = enum {
    SINGLE,
    AND,
    OR,
    LSHIFT,
    RSHIFT,
    NOT,
};

const OpArg = union(enum) {
    reg: []const u8,
    num: u16,

    const Self = @This();
    fn parse(str: []const u8) !Self {
        if (parseInt(u16, str, 10)) |n| {
            return .{ .num = n };
        } else |_| {
            return .{ .reg = str };
        }
    }

    fn value(self: *Self) ?u16 {
        return switch (self.*) {
            .reg => |reg| get_val(reg),
            .num => |n| n,
        };
    }
};

const OpArgs = struct {
    l: OpArg,
    r: OpArg,
};

const Register = struct {
    input: RegInput,
    val: ?u16,

    fn value(self: *Register) ?u16 {
        if (self.val) |v| return v;
        self.val = self.input.value();
        return self.val;
    }

    fn new(str: []const u8) !*?Register {
        const entry = try map.getOrPutValue(str, null);
        return entry.value_ptr;
    }
};

const RegInput = union(Input) {
    SINGLE: OpArg,
    AND: OpArgs,
    OR: OpArgs,
    LSHIFT: OpArgs,
    RSHIFT: OpArgs,
    NOT: OpArg,

    const Self = @This();

    fn value(self: *RegInput) ?u16 {
        switch (self.*) {
            .SINGLE => |*a| return a.value(),
            .AND => |*args| {
                const r = args.r.value() orelse return null;
                const l = args.l.value() orelse return null;
                return l & r;
            },
            .OR => |*args| {
                const r = args.r.value() orelse return null;
                const l = args.l.value() orelse return null;
                return l | r;
            },
            .LSHIFT => |*args| {
                const r = args.r.value() orelse return null;
                const l = args.l.value() orelse return null;
                return l << @as(u4, @truncate(r));
            },
            .RSHIFT => |*args| {
                const r = args.r.value() orelse return null;
                const l = args.l.value() orelse return null;
                return l >> @as(u4, @truncate(r));
            },
            .NOT => |*r| return if (r.value()) |v| ~v else null,
        }
    }
};

const Tokenizer = struct {
    const Self = @This();

    slice: []const u8,

    fn init(comptime bytes: *const [5304:0]u8) Self {
        return .{
            .slice = bytes[0..],
        };
    }

    fn next(self: *Self) ?[]const u8 {
        for (self.slice, 0..) |c, i| {
            if (c == ' ' or c == '\n') {
                const out = self.slice[0..i];
                //print("next: {s}\n", .{out});
                self.slice = self.slice[i + 1 ..];
                return out;
            }
        }
        return null;
    }
};

fn get_val(str: []const u8) ?u16 {
    return map.getEntry(str).?.value_ptr.*.?.value();
}

fn print_reg(str: []const u8) void {
    print("{s}: ", .{str});
    var nul = false;
    if (map.getEntry(str)) |e| {
        if (e.value_ptr.*) |*v| {
            if (v.value()) |n| print("{d}", .{n}) else nul = true;
        } else {
            nul = true;
        }
    } else nul = true;
    if (nul) print("null", .{});
    print("\n", .{});
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // const lines = tokenizeSca([]const u8, data, "\n");
    // while (lines.next()) |line| {

    // }
    var tknzr = Tokenizer.init(data);
    map = StrMap(?Register).init(arena.allocator());
    var tokens = [3][]const u8{ "", "", "" };
    main: while (tknzr.slice.len >= 0) {
        var i: usize = 0;
        while (i < 4) : (i += 1) {
            const t = tknzr.next() orelse break :main;
            if (t[0] == '-') break;
            tokens[i] = t;
        }
        for (tokens[0..i]) |t| {
            print("{s} ", .{t});
        }

        const v = switch (i) {
            1 => RegInput{ .SINGLE = try OpArg.parse(tokens[0]) },
            2 => RegInput{ .NOT = try OpArg.parse(tokens[1]) },
            // {
            //     var entry = try map.getOrPutValue(tokens[1], null);
            //     break .{ .NOT = entry.value_ptr };
            // },
            3 => switch (tokens[1][0]) {
                'A' => RegInput{ .AND = .{
                    .l = try OpArg.parse(tokens[0]),
                    .r = try OpArg.parse(tokens[2]),
                } },
                'O' => RegInput{ .OR = .{
                    .l = try OpArg.parse(tokens[0]),
                    .r = try OpArg.parse(tokens[2]),
                } },
                'L' => RegInput{ .LSHIFT = .{
                    .l = try OpArg.parse(tokens[0]),
                    .r = try OpArg.parse(tokens[2]),
                } },
                'R' => RegInput{ .RSHIFT = .{
                    .l = try OpArg.parse(tokens[0]),
                    .r = try OpArg.parse(tokens[2]),
                } },
                else => unreachable,
            },
            else => unreachable,
        };

        const k = tknzr.next() orelse return error.UnexpectedEOF;
        print("-> {s}\n", .{k});
        const entry = try map.getOrPut(k);
        const ptr = entry.value_ptr;
        ptr.* = Register{
            .input = v,
            .val = null,
        };
    }
    var iter = map.iterator();
    while (iter.next()) |e| {
        e.value_ptr.* = Register{
            .input = e.value_ptr.*.?.input,
            .val = null,
        };
    }
    map.getEntry("b").?.value_ptr.* =  Register{ 
        .input = RegInput{ .SINGLE = .{ .num = 16076 }} ,
        .val = null,
    };
    print_reg("a");

    // const lv = get_val("lv");
    // const lw = get_val("lw");
    // print("lw: {d}, lv: {d}, or: {d}\n", .{ lw, lv, lw | lv });
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
