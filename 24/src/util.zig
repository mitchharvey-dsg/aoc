const std = @import("std");

pub fn countSorted(comptime T: type, haystack: []T, needle: T) i32 {
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

pub fn find(comptime T: type, haystack: []T, needle: T) ?usize {
    for (haystack, 0..) |item, i| {
        if (item == needle) {
            return i;
        }
    }
    return null;
}

pub fn count(comptime T: type, haystack: []T, needle: T) u32 {
    var c: u32 = 0;
    for (haystack) |item| {
        if (item == needle) {
            c += 1;
        }
    }
    return c;
}

pub fn remove(comptime T: type, list: std.ArrayList(T), removeIdx: usize) anyerror!std.ArrayList(T) {
    //     print("Removing index {d} ({d}) from {any}\n", .{ removeIdx, list.items[removeIdx], list.items });

    var newList = std.ArrayList(i32).init(std.heap.c_allocator);
    for (list.items[0..removeIdx]) |item| {
        try newList.append(item);
    }
    for (list.items[removeIdx + 1 ..]) |item| {
        try newList.append(item);
    }

    //     print("Final list: {any}\n", .{newList.items});
    return newList;
}

pub fn swap(comptime T: type, data: []T, from: usize, to: usize) void {
    const temp: T = data[to];
    data[to] = data[from];
    data[from] = temp;
}

pub fn shiftToFront(comptime T: type, data: []T, from: usize) void {
    const temp: T = data[from];
    for (0..from) |i| {
        // print("moving {d} to {d}\n", .{ from - i - 1, from - i });
        data[from - i] = data[from - i - 1];
    }
    data[0] = temp;
    // return data;
}

test "shifting" {
    var original = [_]u32{ 1, 2, 3, 4, 5 };
    shiftToFront(u32, &original, 2);
    try std.testing.expectEqualSlices(u32, &[_]u32{ 3, 1, 2, 4, 5 }, &original);

    var second = [_]u32{ 75, 97, 47, 61, 53 };
    shiftToFront(u32, &second, 1);
    try std.testing.expectEqualSlices(u32, &[_]u32{ 97, 75, 47, 61, 53 }, &second);
}

pub fn dataToArray(comptime T: type, data: []const u8, sep: []const u8, converter: fn ([]const u8) anyerror!T) anyerror![]T {
    const size = std.mem.count(u8, data, sep) + 1;
    var out: []T = try std.heap.c_allocator.alloc(T, size);
    // defer std.heap.c_allocator.free(out); // memory not being freed... this should return a struct...
    var itemIt = std.mem.tokenizeSequence(u8, data, sep);
    var i: usize = 0;
    while (itemIt.next()) |item| {
        const convertedItem = try converter(item);
        out[i] = convertedItem;
        i += 1;
    }
    return out;
}

pub fn strTou32(in: []const u8) anyerror!u32 {
    return try std.fmt.parseInt(u32, in, 10);
}
