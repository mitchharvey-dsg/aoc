const std = @import("std");

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