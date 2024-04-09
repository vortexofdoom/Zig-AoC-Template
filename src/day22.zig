const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day22.txt");

fn Timer(comptime N: u3, comptime E: u8) type {
    return struct {
        const Self = @This();

        rem: u3,

        fn new() Self {
            return Self{.rem = 0};
        }

        fn start() Self {
            return Self{ .rem = N };
        }

        fn effect(self: Self) u8 {
            return if (self.rem > 0) E else 0;
        }

        fn tick(self: Self) Self {
            return Self{ .rem = self.rem -| 1 };
        }
    };
}

const Poison = Timer(6, 3);
const Recharge = Timer(5, 101);
const Shield = Timer(6, 7);

const Spell = enum {
    missile,
    drain,
    shield,
    poison,
    recharge,

    fn cost(self: Spell) u32 {
        return switch (self) {
            .missile => 53,
            .drain => 73,
            .shield => 113,
            .poison => 173,
            .recharge => 229,
        };
    }
};

const State = struct {
    const Self = @This();

    boss_hp: u32,
    player_hp: u32,
    player_mp: u32,
    mp_spent: u32,
    poison: Poison,
    recharge: Recharge,
    shield: Shield,

    fn tick(self: Self, spell: Spell) ?Self {
        var res = self;
        res.player_hp -|= 1;
        if (res.player_hp == 0) return null;
        const cost = spell.cost();
        if (res.player_mp < cost) return null;
        var b_dmg = self.poison.effect();
        res.poison = res.poison.tick();
        res.recharge = res.recharge.tick();
        res.shield = res.shield.tick();
        res.player_mp += res.recharge.effect();
        switch (spell) {
            .missile => b_dmg += 4,
            .drain => {
                b_dmg += 2;
                res.player_hp += 2;
            },
            .shield => res.shield = Shield.start(),
            .poison => res.poison = Poison.start(),
            .recharge => res.recharge = Recharge.start(),
        }
        const p_dmg = 9 - res.shield.effect();
        res.player_mp += res.recharge.effect();
        b_dmg += res.poison.effect();
        if (p_dmg >= self.player_hp and b_dmg < self.boss_hp) return null;
        res.boss_hp -|= b_dmg;
        res.player_hp -|= p_dmg;
        res.player_mp -|= cost;
        res.mp_spent += cost;
        res.poison = res.poison.tick();
        res.recharge = res.recharge.tick();
        res.shield = res.shield.tick();
        return res;
    }
};

var best: u32 = std.math.maxInt(u32);

fn dfs(state: State) u32 {
    if (state.mp_spent >= best) return std.math.maxInt(u32);
    if (state.boss_hp == 0) {
        best = @min(state.mp_spent, best);
        return best;
    }
    if (state.tick(.missile)) |s| _ = dfs(s);
    if (state.tick(.drain)) |s| _ = dfs(s);
    if (state.tick(.poison)) |s| _ = dfs(s);
    if (state.tick(.shield)) |s| _ = dfs(s);
    if (state.tick(.recharge)) |s| _ = dfs(s);
    return best;
}

pub fn main() !void {
    const start = State {
        .boss_hp = 58,
        .player_hp = 50,
        .player_mp = 500,
        .mp_spent = 0,
        .poison = Poison.new(),
        .recharge = Recharge.new(),
        .shield = Shield.new(),
    };
    print("{d}\n", .{dfs(start)});
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
