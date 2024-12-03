const std = @import("std");
const print = std.debug.print;

pub fn count(comptime T: type, haystack: []T, needle: T) i32 {
    // Assume haystack is sorted
    // lazy

    var found = false;
    var c: i32 = 0;

    for (haystack) |item| {
        if (item == needle) {
            found = true;
            c += 1;
        } else if (found) { // we already found the section of needles, break and return
            break;
        }
    }

    return c;
}

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

    var diff: i32 = 0;
    for (listA.items[0..]) |a| {
        diff += a * count(i32, listB.items, a);
    }

    print("{d}", .{diff});
}
