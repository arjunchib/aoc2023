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

    try stdout.print("part1: {d}\npart2: {!}\n", .{ part1(data), part2(data) });

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

fn part2(input: []const u8) !usize {
    var output: usize = 0;
    var it = std.mem.tokenizeAny(u8, input, "\n");
    var hash_map = std.StringHashMap(usize).init(std.heap.page_allocator);
    defer hash_map.deinit();
    try init_hash_map(&hash_map);
    while (it.next()) |x| {
        var first: usize = undefined;
        var last: usize = undefined;
        var first_i: usize = std.math.maxInt(usize);
        var last_i: usize = 0;
        var iter = hash_map.keyIterator();
        while (iter.next()) |number| {
            const index = std.mem.indexOf(u8, x, number.*);
            const last_index = std.mem.lastIndexOf(u8, x, number.*);
            if (index) |i| {
                if (i <= first_i) {
                    first_i = i;
                    first = hash_map.get(number.*).?;
                }
                if (i >= last_i) {
                    last_i = i;
                    last = hash_map.get(number.*).?;
                }
            }
            if (last_index) |i| {
                if (i <= first_i) {
                    first_i = i;
                    first = hash_map.get(number.*).?;
                }
                if (i >= last_i) {
                    last_i = i;
                    last = hash_map.get(number.*).?;
                }
            }
        }
        // std.debug.print("{s} {} {}\n", .{ x, first, last });
        output += first * 10 + last;
    }
    return output;
}

fn init_hash_map(hash_map: anytype) !void {
    try hash_map.put("one", 1);
    try hash_map.put("two", 2);
    try hash_map.put("three", 3);
    try hash_map.put("four", 4);
    try hash_map.put("five", 5);
    try hash_map.put("six", 6);
    try hash_map.put("seven", 7);
    try hash_map.put("eight", 8);
    try hash_map.put("nine", 9);
    try hash_map.put("0", 0);
    try hash_map.put("1", 1);
    try hash_map.put("2", 2);
    try hash_map.put("3", 3);
    try hash_map.put("4", 4);
    try hash_map.put("5", 5);
    try hash_map.put("6", 6);
    try hash_map.put("7", 7);
    try hash_map.put("8", 8);
    try hash_map.put("9", 9);
}

test part1 {
    try std.testing.expect(part1(case1) == 142);
}

test part2 {
    try std.testing.expect(try part2(case1) == 142);
    try std.testing.expect(try part2(case2) == 281);
}
