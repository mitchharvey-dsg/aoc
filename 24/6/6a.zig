const std = @import("std");
const mvzr = @import("lib/mvzr.zig");
const util = @import("util.zig");

const print = std.debug.print;

const input = @embedFile("input");

pub fn passthrough(v: []const u8) anyerror![]const u8 {
    return v;
}

pub fn main() !void {
    // load map
    var guardDir: usize = 0; //URDL
    var guardI: usize = 0;
    var guardJ: usize = 0;
    const map = try util.dataToArray([]const u8, input, "\n", passthrough);
    print("{any}\n{s}\n", .{ guardDir, map });
    for (map, 0..) |row, i| {
        for (row, 0..) |v, j| {
            if (v == '^') {
                guardI = i;
                guardJ = j;
                break;
            }
        }
        if (guardI != 0) {
            break;
        }
    }

    // navigate
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // defer std.debug.assert(gpa.deinit() == .ok);
    // const allocator = gpa.allocator();
    // var path = std.StringHashMap(void).init(std.heap.page_allocator);
    // defer path.deinit();
    // var strbuf: [40]u8 = undefined;
    var path: [][]bool = try std.heap.c_allocator.alloc([]bool, map.len);
    for (0..map.len) |i| {
        path[i] = try std.heap.c_allocator.alloc(bool, map[0].len);
    }
    while (true) {
        // const str = try std.fmt.bufPrint(&strbuf, "{d}:{d}", .{ guardI, guardJ });
        // path.get(str) orelse try path.put(str, {});
        path[guardI][guardJ] = true;
        switch (guardDir) {
            0 => {
                if (guardI <= 0) {
                    break;
                }
                if (map[guardI - 1][guardJ] == '#') {
                    guardDir = 1;
                } else {
                    guardI -= 1;
                }
            },
            1 => {
                if (guardJ >= map[0].len-1) {
                    break;
                }
                if (map[guardI][guardJ + 1] == '#') {
                    guardDir = 2;
                } else {
                    guardJ += 1;
                }
            },
            2 => {
                if (guardI >= map.len-1) {
                    break;
                }
                if (map[guardI + 1][guardJ] == '#') {
                    guardDir = 3;
                } else {
                    guardI += 1;
                }
            },
            3 => {
                if (guardJ <= 0) {
                    break;
                }
                if (map[guardI][guardJ - 1] == '#') {
                    guardDir = 0;
                } else {
                    guardJ -= 1;
                }
            },
            else => {
                std.debug.panic("unknown dir {d}", .{guardDir});
            },
        }
    }
    var sum: u32 = 0;
    for (path) |row| {
        sum += util.count(bool, row, true);
    }
    print("{d}\n", .{sum});
}
