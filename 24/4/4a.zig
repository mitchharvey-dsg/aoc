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

    for (grid, 0..) |r, rowidx| {
        for (r, 0..) |cell, colidx| {
            if (cell == 'X') {
                for ([_]i32{ -1, 0, 1 }) |x| {
                    for ([_]i32{ -1, 0, 1 }) |y| {
                        // don't compare against self
                        if (x == 0 and y == 0) {
                            continue;
                        }

                        // bounds
                        if ((rowidx <= 2 and x == -1) or (rowidx >= N - 3 and x == 1) or (colidx <= 2 and y == -1) or (colidx >= N - 3 and y == 1)) {
                            continue;
                        }

                        const row: i32 = @intCast(rowidx);
                        const col: i32 = @intCast(colidx);

                        const x2: usize = @intCast(row + x);
                        const y2: usize = @intCast(col + y);
                        const x3: usize = @intCast(row + (x * 2));
                        const y3: usize = @intCast(col + (y * 2));
                        const x4: usize = @intCast(row + (x * 3));
                        const y4: usize = @intCast(col + (y * 3));

                        if (grid[x2][y2] == 'M' and grid[x3][y3] == 'A' and grid[x4][y4] == 'S') {
                            xmascount += 1;
                        }
                    }
                }
            }
        }
    }

    print("xmascount: {d}\n", .{xmascount});
}
