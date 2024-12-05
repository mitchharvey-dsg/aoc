const std = @import("std");
const mvzr = @import("lib/mvzr.zig");
const util = @import("util.zig");

const print = std.debug.print;

const rulesinput = @embedFile("inputrules");
const input = @embedFile("input");

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
    while (it.next()) |seq| {
        print("{s} => ", .{seq});
        const numbers = try dataToArray(u32, seq, ",", strTou32);
        print("{any} ", .{numbers});
        var valid = true;
        for (numbers, 0..) |num, i| {
            if (ruleset.get(num)) |rule| {
                for (rule.items) |predecessor| {
                    for (numbers[0..i]) |cur| {
                        if (cur == predecessor) {
                            valid = false;
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
        print("is valid: {any}\n", .{valid});
        if (valid) {
            numvalid += numbers[numbers.len/2];
        }
        // var itemIt = std.mem.tokenizeScalar(u8, seq, ',');
        // // var i: usize = 0;
        // var valid = true;
        // while (itemIt.next()) |item| {
        //     valid = false;
        // const itemInt = try std.fmt.parseInt(u32, item, 10);
        // if (ruleset.get(itemInt)) |rule| {
        //     for (rule.items) |predecessor| {
        //         for (seq[0..i]) |cur| {
        //             if (cur == predecessor) {
        //                 valid = false;
        //                 break;
        //             }
        //         }
        //         if (!valid) {
        //             break;
        //         }
        //     }
        // }
        // i += 1;
        // }
        // print("Valid {any}\n", .{valid});
    }
    print("Total Valid {d}\n", .{numvalid});
}
