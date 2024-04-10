const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Queue = std.PriorityQueue;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day11.txt");

const Elems = struct {
    pm: u2,
    pu: u2,
    ru: u2,
    sr: u2,
    tm: u2,
};

const Pair = struct {
    gen: u2,
    chip: u2,

    fn done(self: Pair) bool {
        return self.gen == 3 and self.chip == 3;
    }

    fn fried(self: Pair, other: Pair) bool {
        return self.chip != self.gen and other.gen == self.chip;
    }

    fn lt(_: void, l: Pair, r: Pair) bool {
        return @as(usize, l.chip) + l.gen < @as(usize, r.chip) + r.gen;
    }
};

const QEntry = struct {
    steps: usize,
    state: State,
};

const State = struct {
    const Self = @This();
    pairs: [5]Pair,
    f: u2,

    fn print(self: Self) void {
        for (0..4) |f| {
            if (self.f == 3 - f) std.debug.print("E|", .{}) else std.debug.print(" |", .{});
            for (self.pairs, 0..) |p, i| {
                const c = p.chip == 3 - f;
                const g = p.gen == 3 - f;
                if (c and g) std.debug.print("[C{d}, G{d}]", .{i, i})
                else if (c) std.debug.print("[C{d}]", .{i})
                else if (g) std.debug.print("[G{d}]", .{i});
            }
            std.debug.print("\n", .{});
        }
        std.debug.print("------------\n", .{});
    }

    fn update(self: Self, items: [2]?Item, up: bool) ?Self {
        var new = self;
        if (up) {
            if (new.f == 3) return null else new.f += 1;
        } else {
            if (new.f == 0) return null else new.f -= 1;
        }
        for (items) |maybe_item| {
            if (maybe_item) |item| {
                const to_change = new.get(item);

                if (up) {
                    if (to_change.* == 3) return null else to_change.* += 1;
                } else {
                    if (to_change.* == 0) return null else to_change.* -= 1;
                }
            }
        }
        sort(Pair, &new.pairs, {}, Pair.lt);
        // return new;
        // return if (new.bad()) null else new;
        if (new.bad()) return null else {
            // new.print();
            return new;
        }
    }

    fn done(self: Self) bool {
        for (self.pairs) |p| if (!p.done()) return false;
        return true;
    }

    fn bad(self: Self) bool {
        for (0..4) |i| {
            for (i + 1..5) |j| {
                if (self.pairs[i].fried(self.pairs[j])) return true;
            }
        }
        return false;
    }

    fn get(self: *Self, item: Item) *u2 {
        return switch (item) {
            .gen => |i| &self.pairs[i].gen,
            .chip => |i| &self.pairs[i].chip,
        };
    }
};

const Item = union(enum) {
    gen: usize,
    chip: usize,
};

// var map: Map(State, void) = undefined;

fn lt(_: void, l: QEntry, r: QEntry) std.math.Order {
    return switch (std.math.order(l.steps, r.steps)) {
        .eq => {
            var a_sum: usize = l.state.f;
            var b_sum: usize = r.state.f;
            for (l.state.pairs, r.state.pairs) |a, b| {
                a_sum += @as(usize, a.chip) + a.gen;
                b_sum += @as(usize, b.chip) + b.gen;
            }
            return std.math.order(b_sum, a_sum);
        },
        else => |o| o,
    };
}

const Entry = struct {
    idx: usize,
    prev: ?usize,
};



// fn order(_: void, a: Update, b: Update) std.math.Order {
//     var i: usize = 0;
//     while (a.items[i]) |_| : (i += 1) {}
//     var j: usize = 0;
//     while (b.items[j]) |_| : (j += 1) {}
//     if (up) {
//         if (j > i)
//     }
// }


// var q: Queue(State, void, lt) = undefined; //.init(gpa, {});

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var map = Map(State, Entry).init(arena.allocator());
    var buf = try List(Item).initCapacity(arena.allocator(), 10);
    var states = List(State).init(arena.allocator());

    const start = State{
    //_ = State{
        .pairs = [_]Pair{
            Pair{.chip = 0, .gen = 0},
            Pair{.chip = 1, .gen = 0},
            Pair{.chip = 1, .gen = 0},
            Pair{.chip = 2, .gen = 2},
            Pair{.chip = 2, .gen = 2},
        },
        .f = 0,
    };

    var q = Queue(QEntry, void, lt).init(arena.allocator(), {});
    try q.add(QEntry{ .state = start, .steps = 0});
    try map.put(start, Entry{.idx = 0, .prev = null});
    try states.append(start);
    var res: usize = 1;
    while (q.peek()) |_| : (res += 1) {
        const curr_cnt = q.count();
        for (0..curr_cnt) |_| {
            const next = q.remove();
            var curr = next.state;
            if (curr.done()) {
                print("{d}\n", .{next.steps});
                var s = curr;
                var i:usize = 0;
                while (map.get(s).?.prev) |p| : ({s = states.items[p]; i += 1;}) {
                    s.print();
                }
                start.print();
                print("{d}\n", .{i});
                while (q.removeOrNull()) |_| {}
                q.deinit();
                break;
            }
            for (curr.pairs, 0..) |p, i| {
                if (p.chip == curr.f) try buf.append(Item{.chip = i});
                if (p.gen == curr.f) try buf.append(Item{.gen = i});
            }

            for (0..buf.items.len) |i| {
                for (i..buf.items.len) |j| {
                    const a, const b = if (i == j) .{ buf.items[i], null } else .{ buf.items[i], buf.items[j] };
                    for ([_]bool{true, false}) |up| {
                        if (curr.update([_]?Item{a, b}, up)) |s| {
                            if (map.get(s)) |_| continue;
                            const old = map.get(curr).?;
                            const new = Entry{
                                .idx = states.items.len,
                                .prev = old.idx,
                            };
                            try map.put(s, new);
                            try states.append(s);
                            try q.add(QEntry{ .steps = res, .state = s });
                        }
                    }
                }
            }
            buf.clearRetainingCapacity();
        }
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
