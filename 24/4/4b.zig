const std = @import("std");
const mvzr = @import("lib/mvzr.zig");
const util = @import("util.zig");

const print = std.debug.print;

const input = @embedFile("input");

const N = 140;
var grid: [N][N]u8 = undefined;

pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    // var lines = std.mem.splitScalar(u8, input, '\n');

    // Convert input to grid

    var i: u32 = 0;
    while (it.next()) |line| {
        // print("{s}: ", .{line});
        for (line, 0..) |char, j| {
            grid[i][j] = char;
        }
        i += 1;
    }

    var xmascount: u32 = 0;

    for (grid[1 .. N - 1], 1..) |r, rowidx| {
        for (r[1 .. N - 1], 1..) |cell, colidx| {
            if (cell == 'A') {
                //..
                const row: i32 = @intCast(rowidx);
                const col: i32 = @intCast(colidx);

                const x1: usize = @intCast(row + 1);
                const y1: usize = @intCast(col + 1);
                const l1 = grid[x1][y1];

                const x2: usize = @intCast(row - 1);
                const y2: usize = @intCast(col + 1);
                const l2 = grid[x2][y2];

                const x3: usize = @intCast(row + 1);
                const y3: usize = @intCast(col - 1);
                const l3 = grid[x3][y3];

                const x4: usize = @intCast(row - 1);
                const y4: usize = @intCast(col - 1);
                const l4 = grid[x4][y4];

                // lazy
                if ((l1 == 'M' and l4 == 'S') or (l1 == 'S' and l4 == 'M')) {
                    if ((l2 == 'M' and l3 == 'S') or (l2 == 'S' and l3 == 'M')) {
                        xmascount += 1;
                    }
                }
            }
        }
    }

    print("xmascount: {d}\n", .{xmascount});
}
