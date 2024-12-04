const std = @import("std");
const mvzr = @import("lib/mvzr.zig");
const util = @import("util.zig");
const print = std.debug.print;

const input = @embedFile("input");

pub fn main() !void {
    var n: u32 = 0;
    var inputBuf: [256]u8 = undefined;
    var hashBuf: [16]u8 = undefined;
    var hexHashBuf: [32]u8 = undefined;
    while (true) {
        // concat input with n
        // slice is the string as formatted, buf is the entire buf, regardless of null terminated
        const inputSlice = try std.fmt.bufPrint(&inputBuf, "{s}{d}", .{ input, n });

        // get hash
        std.crypto.hash.Md5.hash(inputSlice, &hashBuf, .{});

        // check if first two bytes are 0
        if (std.mem.startsWith(u8, &hashBuf, &[_]u8{ 0, 0 })) {
            // probably could just always convert to hexstring and compare here but idk
            const hexHashSlice = try std.fmt.bufPrint(&hexHashBuf, "{}", .{std.fmt.fmtSliceHexLower(&hashBuf)});
            print("{s} => {s}\n", .{ inputSlice, hexHashSlice });
            if (std.mem.startsWith(u8, hexHashSlice, "00000")) {
                print("Found part 1\n", .{});
                if (std.mem.startsWith(u8, hexHashSlice, "000000")) {
                    print("Found part 2\n", .{});
                    return;
                }
            }
        }

        if (n > 10000000) {
            print("Did not find solution after {d} cycles.", .{n});
            return;
        }
        n += 1;
    }
}
