const std = @import("std");
const data = @embedFile("./input.txt");
const case1 = @embedFile("./case1.txt");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("part1: {d}\npart2: {!}\n", .{ part1(data), part2(data) });

    try bw.flush(); // don't forget to flush!
}

fn part1(input: []const u8) usize {
    var output: usize = 0;
    var line_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_it.next()) |line| {
        var game_it = std.mem.splitSequence(u8, line, ": ");
        const game = game_it.first();
        const records = game_it.rest();
        var id_it = std.mem.splitScalar(u8, game, ' ');
        _ = id_it.next().?;
        const id = std.fmt.parseInt(usize, id_it.next().?, 10) catch unreachable;
        var record_it = std.mem.tokenizeAny(u8, records, ",; ");
        const valid = while (record_it.next()) |num_str| {
            const num = std.fmt.parseInt(usize, num_str, 10) catch unreachable;
            const color = record_it.next().?;
            // std.debug.print("{d} {s}\n", .{ num, color });
            if (std.mem.eql(u8, color, "red") and num > 12 or
                std.mem.eql(u8, color, "green") and num > 13 or
                std.mem.eql(u8, color, "blue") and num > 14)
            {
                break false;
            }
        } else true;
        if (valid) output += id;
    }
    return output;
}

fn part2(input: []const u8) usize {
    var output: usize = 0;
    var line_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_it.next()) |line| {
        var game_it = std.mem.splitSequence(u8, line, ": ");
        const game = game_it.first();
        const records = game_it.rest();
        var id_it = std.mem.splitScalar(u8, game, ' ');
        _ = id_it.next().?;
        const id = std.fmt.parseInt(usize, id_it.next().?, 10) catch unreachable;
        _ = id;
        var record_it = std.mem.tokenizeAny(u8, records, ",; ");
        var red: usize = 0;
        var green: usize = 0;
        var blue: usize = 0;
        while (record_it.next()) |num_str| {
            const num = std.fmt.parseInt(usize, num_str, 10) catch unreachable;
            const color = record_it.next().?;
            if (std.mem.eql(u8, color, "red") and num > red) {
                red = num;
            } else if (std.mem.eql(u8, color, "green") and num > green) {
                green = num;
            } else if (std.mem.eql(u8, color, "blue") and num > blue) {
                blue = num;
            }
            // std.debug.print("{d} {s}\n", .{ num, color });
        }
        output += red * green * blue;
    }
    return output;
}

test part1 {
    try std.testing.expect(part1("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green") == 1);
    try std.testing.expect(part1("Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue") == 2);
    try std.testing.expect(part1("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red") == 0);
    try std.testing.expect(part1("Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red") == 0);
    try std.testing.expect(part1("Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green") == 5);
    try std.testing.expect(part1(case1) == 8);
}

test part2 {
    try std.testing.expect(part2("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green") == 48);
    try std.testing.expect(part2("Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue") == 12);
    try std.testing.expect(part2("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red") == 1560);
    try std.testing.expect(part2("Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red") == 630);
    try std.testing.expect(part2("Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green") == 36);
    try std.testing.expect(part2(case1) == 2286);
}
