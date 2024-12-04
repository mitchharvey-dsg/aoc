const std = @import("std");
const mvzr = @import("lib/mvzr.zig");
const util = @import("util.zig");

const print = std.debug.print;

const input = @embedFile("input");

const N = 140;
var grid: [N][N]u8 = undefined;

pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');
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
        const row = @as(i32, @intCast(rowidx));
        for (r, 0..) |cell, colidx| {
            const col = @as(i32, @intCast(colidx));
            if (cell == 'X') {
                for ([_]i32{ -1, 0, 1 }) |x| {
                    for ([_]i32{ -1, 0, 1 }) |y| {
                        // don't compare against self
                        if (x == 0 and y == 0) {
                            continue;
                        }

                        // bounds
                        if ((row <= 2 and x == -1) or (row >= N - 3 and x == 1) or (col <= 2 and y == -1) or (col >= N - 3 and y == 1)) {
                            continue;
                        }

                        var found = true;
                        for ("MAS", [_]i32{ 1, 2, 3 }) |c, n| {
                            if (grid[@as(usize, @intCast(row + (x * n)))][@as(usize, @intCast(col + (y * n)))] != c) {
                                found = false;
                                break;
                            }
                        }
                        if (found) {
                            xmascount += 1;
                        }
                    }
                }
            }
        }
    }

    print("xmascount: {d}\n", .{xmascount});
}
