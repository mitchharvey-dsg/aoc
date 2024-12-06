const std = @import("std");
const mvzr = @import("lib/mvzr.zig");
const util = @import("util.zig");

const print = std.debug.print;

const rulesinput = @embedFile("inputrules");
const input = @embedFile("input");

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

pub fn main() !void {
    // Parse Rules
    var ruleset = std.AutoHashMap(usize, std.ArrayList(u32)).init(std.heap.c_allocator);
    defer ruleset.deinit();
    var ruleIt = std.mem.tokenizeScalar(u8, rulesinput, '\n');
    while (ruleIt.next()) |rule| {
        var ruleItemIt = std.mem.tokenizeScalar(u8, rule, '|');
        const first = try std.fmt.parseInt(u32, ruleItemIt.next().?, 10);
        const second = try std.fmt.parseInt(u32, ruleItemIt.next().?, 10);

        var seconds = ruleset.get(first) orelse std.ArrayList(u32).init(std.heap.c_allocator);

        try seconds.append(second);

        try ruleset.put(first, seconds);
    }

    // Print Rules
    var rulesetIt = ruleset.iterator();
    while (rulesetIt.next()) |rule| {
        print("{d} => {any}\n", .{ rule.key_ptr.*, rule.value_ptr.items });
    }

    // Check Rules
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    var numvalid: u32 = 0;
    var numaltered: u32 = 0;
    while (it.next()) |seq| {
        print("{s} => ", .{seq});
        const numbers = try dataToArray(u32, seq, ",", strTou32);
        print("{any} ", .{numbers});
        var valid = true;
        var altered = false;
        for (0..9999999) |_| {
            valid = true;
            for (numbers, 0..) |num, i| {
                if (ruleset.get(num)) |rule| {
                    for (rule.items) |predecessor| {
                        for (numbers[0..i], 0..) |cur, j| {
                            if (cur == predecessor) {
                                valid = false;
                                altered = true;
                                // shiftToFront(u32, numbers, i);
                                swap(u32, numbers, i, j);
                                // print("MOVED {d} => {any} ", .{ i, numbers });
                                break;
                            }
                        }
                        if (!valid) {
                            break;
                        }
                    }
                }
                if (!valid) {
                    break;
                }
            }
            if (valid) {
                break;
            }
        }
        print("is valid: {any}\n", .{valid});
        if (altered) {
            numaltered += numbers[numbers.len / 2];
        } else {
            numvalid += numbers[numbers.len / 2];
        }
    }
    print("Total Valid {d}\nTotal Valid Altered {d}\n", .{ numvalid, numaltered });
}
