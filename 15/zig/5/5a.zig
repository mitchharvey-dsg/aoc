const std = @import("std");
const mvzr = @import("lib/mvzr.zig");
const util = @import("util.zig");

const print = std.debug.print;

const input = @embedFile("input");

pub fn main() !void {
    var it = std.mem.tokenizeScalar(u8, input, '\n');

    const naughtyRegex = mvzr.compile("(ab|cd|pq|xy)").?;
    const threeVowelRegex = mvzr.compile(".*[aeiou].*[aeiou].*[aeiou].*").?;
    // mvzr doesn't support capture groups, so doing sliding window instead
    // const doubleLetterRegex = mvzr.compile(".*(.)\\1.*").?;

    var nice: u32 = 0;

    while (it.next()) |line| {
        print("{s}: ", .{line});
        if (naughtyRegex.match(line)) |m| {
            print("naughty string detected: {s}\n", .{m});
            continue;
        }

        if (!threeVowelRegex.isMatch(line)) {
            print("three vowels not detected\n", .{});
            continue;
        }

        var hasDoubleLetter = false;
        var doubleLetterWindow = std.mem.window(u8, line, 2, 1);
        while (doubleLetterWindow.next()) |window| {
            // if (window.len < 2) {
            //     continue;
            // }
            if (window[0] == window[1]) {
                hasDoubleLetter = true;
                break;
            }
        }
        if (!hasDoubleLetter) {
            print("double letter not detected\n", .{});
            continue;
        }

        print("valid\n", .{});
        nice += 1;
    }

    print("nice: {d}\n", .{nice});
}
