const std = @import("std");
const Allocator = std.mem.Allocator;
const fs = std.fs;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try fs.cwd().openFile("input6", .{});
    defer input.close();

    const size = try input.getEndPos();
    const buffer = try allocator.alloc(u8, size);
    defer allocator.free(buffer);

    _ = try input.readAll(buffer);

    var lines = std.mem.tokenizeAny(u8, buffer, "\n");
    var arr = std.ArrayList(std.ArrayList(u8)).init(allocator);
    defer arr.deinit();

    while (lines.next()) |line| {
        var row = std.ArrayList(u8).init(allocator);
        try row.appendSlice(line);
        try arr.append(row);
    }

    var x: u64 = undefined;
    var y: u64 = undefined;
    var direction: u8 = 'u';

    const row = arr.items.len;
    const col = arr.items[0].items.len;

    var map = try allocator.alloc([]u8, row);
    defer allocator.free(map);

    for (0..row) |i| {
        map[i] = try allocator.alloc(u8, row);
        for (0..col) |j|
            map[i][j] = arr.items[i].items[j];
    }

    for (0..row) |i| {
        for (0..col) |j| {
            if (map[i][j] == '^') {
                x = i;
                y = j;
            }
        }
    }

    while (x >= 0 and x < row and y >= 0 and y < col) {
        if (x == 0 or x == row - 1 or y == 0 or y == col - 1)
            break;

        switch (direction) {
            'u' => {
                while (x >= 0 and map[x][y] != '#') : (x -= 1) {
                    map[x][y] = 'X';
                }
                x += 1;
                map[x][y] = '^';
                direction = 'r';
            },
            'd' => {
                while (x < row and map[x][y] != '#') : (x += 1)
                    map[x][y] = 'X';
                x -= 1;
                map[x][y] = '^';
                direction = 'l';
            },
            'l' => {
                while (y >= 0 and map[x][y] != '#') : (y -= 1)
                    map[x][y] = 'X';
                y += 1;
                map[x][y] = '^';
                direction = 'u';
            },
            'r' => {
                while (y < col and map[x][y] != '#') : (y += 1)
                    map[x][y] = 'X';
                y -= 1;
                map[x][y] = '^';
                direction = 'd';
            },
            else => {
                break;
            },
        }
    }
    map[x][y] = 'X';

    var count: u64 = 0;
    for (0..row) |i| {
        for (0..col) |j| {
            if (map[i][j] == 'X') {
                count += 1;
            }
        }
    }

    std.debug.print("{d}\n", .{count});
}

fn printMap(map: [][]u8, row: usize, col: usize) void {
    for (0..row) |i| {
        for (0..col) |j| {
            std.debug.print("{c}", .{map[i][j]});
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("\n", .{});
}
