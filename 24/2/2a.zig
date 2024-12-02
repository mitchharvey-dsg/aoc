const std = @import("std");

pub fn main() !void {
    var safe: u32 = 0;
    var unsafe: u32 = 0;

    var file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    const stdout = std.io.getStdOut().writer();
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try stdout.print("{s}\n", .{line});

        var it = std.mem.splitScalar(u8, line, ' ');
        var last: i32 = -1;
        var curr: i32 = -1;
        var increasing = true;
        var seqsafe = true;
        while (it.next()) |x| {
            const fixedx = try std.fmt.parseInt(i32, x, 10);
            if (last == -1) {
                last = fixedx;
                continue;
            }
            if (curr == -1) {
                if (last < fixedx) {
                    increasing = true;
                } else {
                    increasing = false;
                }
            }

            curr = fixedx;
            const diff = curr - last;
            std.debug.print("Comparing {d} to {d}: ", .{ last, curr });
            last = curr;

            if (increasing and diff < 0) {
                std.debug.print("Unsafe because increasing but found decreasing\n", .{});
                seqsafe = false;
                break;
            }

            if (!increasing and diff > 0) {
                std.debug.print("Unsafe because decreasing but found increasing\n", .{});
                seqsafe = false;
                break;
            }

            const adiff = @abs(diff);
            if (adiff < 1 or adiff > 3) {
                std.debug.print("Unsafe because gap of {d} < 1 or > 3\n", .{adiff});
                seqsafe = false;
                break;
            }

            std.debug.print("safe! {d} {d}\n", .{ diff, adiff });
        }
        if (seqsafe) {
            std.debug.print("Sequence safe!\n", .{});
            safe += 1;
        } else {
            std.debug.print("Sequence UNsafe!\n", .{});
            unsafe += 1;
        }
        std.debug.print("CURR: UNSAFE: {d}\tSAFE: {d}\n", .{ unsafe, safe });
    }
    std.debug.print("UNSAFE: {d}\tSAFE: {d}\n", .{ unsafe, safe });
}
