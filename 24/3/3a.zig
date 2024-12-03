const std = @import("std");
const mvzr = @import("lib/mvzr.zig");
const util = @import("util.zig");
const print = std.debug.print;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("../3/input", .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [4096]u8 = undefined;

    var out: i32 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const regex = mvzr.compile("mul\\(\\d{1,3},\\d{1,3}\\)").?;
        const numRegex = mvzr.compile("\\d{1,3}").?;
        var iter = regex.iterator(line);
        while (iter.next()) |m| {
            var numIter = numRegex.iterator(m.slice);
            const a = try std.fmt.parseInt(i32, numIter.next().?.slice, 10);
            const b = try std.fmt.parseInt(i32, numIter.next().?.slice, 10);
            print("match: {s} => {d} {d}\n", .{ m.slice, a, b });
            out += a * b;
        }
    }

    print("{d}\n", .{out});
}
