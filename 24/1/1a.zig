const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("../1/input", .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    var listA = std.ArrayList(i32).init(std.heap.c_allocator);
    defer listA.deinit();

    var listB = std.ArrayList(i32).init(std.heap.c_allocator);
    defer listB.deinit();
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var lineIterator = std.mem.splitSequence(u8, line, "   ");

        const x = lineIterator.next();
        const parsedX = try std.fmt.parseInt(i32, x.?, 10);
        try listA.append(parsedX);

        const y = lineIterator.next();
        const parsedY = try std.fmt.parseInt(i32, y.?, 10);
        try listB.append(parsedY);
    }

    std.mem.sort(i32, listA.items, {}, comptime std.sort.desc(i32));
    std.mem.sort(i32, listB.items, {}, comptime std.sort.desc(i32));

    var diff: u32 = 0;
    for (listA.items[0..], listB.items[0..]) |a, b| {
        if (a != b) {
            diff += @abs(a - b);
        }
    }

    print("{d}", .{diff});
}
