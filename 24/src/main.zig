const std = @import("std");
const print = std.debug.print;

pub fn remove(comptime T: type, list: std.ArrayList(T), removeIdx: usize) anyerror!std.ArrayList(T) {
    print("Removing index {d} ({d}) from {any}\n", .{ removeIdx, list.items[removeIdx], list.items });

    var newList = std.ArrayList(i32).init(std.heap.c_allocator);
    for (list.items[0..removeIdx]) |item| {
        try newList.append(item);
    }
    for (list.items[removeIdx + 1 ..]) |item| {
        try newList.append(item);
    }

    print("Final list: {any}\n", .{newList.items});
    return newList;
}

pub fn seqSafe(lineList: std.ArrayList(i32)) anyerror!bool {
    // print("Evaluating {any}\n", .{lineList.items});

    const increasing = lineList.items[0] < lineList.items[1];

    for (lineList.items[1..], 1..) |curr, i| {
        const last = lineList.items[i - 1];
        const diff: i32 = curr - last;
        // print("Comparing {d} to {d}: ", .{ last, curr });

        if (increasing and diff < 0) {
            // print("Unsafe because increasing but found decreasing\n", .{});
            return false;
        }

        if (!increasing and diff > 0) {
            // print("Unsafe because decreasing but found increasing\n", .{});
            return false;
        }

        const adiff = @abs(diff);
        if (adiff < 1 or adiff > 3) {
            // print("Unsafe because gap of {d} < 1 or {d} > 3\n", .{ adiff, adiff });
            return false;
        }
    }
    return true;
}

pub fn main() !void {
    var safe: u32 = 0;
    var n: u32 = 0;

    var file = try std.fs.cwd().openFile("../2/input", .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        n += 1;
        // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        // const allocator = gpa.allocator();
        // var lineList = std.ArrayList(u32).init(allocator);
        var lineList = std.ArrayList(i32).init(std.heap.c_allocator);
        defer lineList.deinit();
        var lineIterator = std.mem.splitScalar(u8, line, ' ');
        while (lineIterator.next()) |x| {
            const parsed = try std.fmt.parseInt(i32, x, 10);
            try lineList.append(parsed);
        }

        // iterate through array, if unsafe, try removing that level and retry
        // if still unsafe, then unsafe, else safe

        // if (try seqSafe(lineList, true)) {
        //     print("Sequence safe!\n", .{});
        //     safe += 1;
        // } else {
        //     const newList = try remove(i32, lineList, lineList.items.len-1); //lazy
        //     if (try seqSafe(newList, false)) {
        //         print("Sequence safe after removing end!\n", .{});
        //         safe += 1;
        //     } else {
        //         print("Sequence UNsafe!\n", .{});
        //         unsafe += 1;
        //     }
        // }
        if (try seqSafe(lineList)) {
            // print("Sequence safe first try!\n", .{});
            safe += 1;
        } else {
            // var foundsafe = false;
            for (0..lineList.items.len) |i| {
                const newList = try remove(i32, lineList, i);
                if (try seqSafe(newList)) {
                    print("Sequence safe after removing! {d} {any} => {any}\n", .{ i, lineList.items, newList.items });
                    // foundsafe = true;
                    safe += 1;
                    break;
                }
            }
            // if (!foundsafe) {
            //     print("Sequence unsafe even after removing! {any}\n", .{lineList.items});
            //     unsafe += 1;
            // }
        }
        print("{d} CURR:\tSAFE: {d}\n", .{ n, safe });
    }
    print("\tSAFE: {d}\n", .{safe});
}
