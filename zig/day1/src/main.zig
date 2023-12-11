const std = @import("std");
const data = @embedFile("./input.txt");

const case1 =
    \\1abc2
    \\pqr3stu8vwx
    \\a1b2c3d4e5f
    \\treb7uchet
;

const case2 =
    \\two1nine
    \\eightwothree
    \\abcone2threexyz
    \\xtwone3four
    \\4nineeightseven2
    \\zoneight234
    \\7pqrstsixteen
;

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("part1: {d}\npart2: {d}\n", .{ part1(data), 0 });

    try bw.flush(); // don't forget to flush!
}

fn part1(input: []const u8) u32 {
    var output: u32 = 0;
    var it = std.mem.tokenizeAny(u8, input, "\n");
    while (it.next()) |x| {
        var first: ?u8 = null;
        var last: u8 = undefined;
        for (x) |elem| {
            if (std.fmt.charToDigit(elem, 10)) |num| {
                if (first == null) {
                    first = num;
                }
                last = num;
            } else |_| {}
        }
        // std.debug.print("{?}{?}\n", .{ first, last });
        output += first.? * 10 + last;
    }
    return output;
}

fn part2(input: []const u8) u32 {
    var output: u32 = 0;
    var it = std.mem.tokenizeAny(u8, input, "\n");
    while (it.next()) |x| {
        var first: ?u8 = null;
        var last: u8 = undefined;
        for (x) |elem| {
            if (std.fmt.charToDigit(elem, 10)) |num| {
                if (first == null) {
                    first = num;
                }
                last = num;
            } else |_| {}
        }
        // std.debug.print("{?}{?}\n", .{ first, last });
        output += first.? * 10 + last;
    }
    return output;
}

test part1 {
    try std.testing.expect(part1(case1) == 142);
}

// test part2 {
//     try std.testing.expect(part2(case1) == 142);
//     try std.testing.expect(part2(case2) == 281);
// }
