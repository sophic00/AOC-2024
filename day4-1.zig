const std = @import("std");
const Allocator = std.mem.Allocator;
const fs = std.fs;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try fs.cwd().openFile("input4", .{});
    defer input.close();

    const size = try input.getEndPos();
    const buffer = try allocator.alloc(u8, size);
    defer allocator.free(buffer);

    _ = try input.readAll(buffer);

    var lines = std.mem.tokenizeAny(u8, buffer, "\n");
    var arr = std.ArrayList(std.ArrayList(u8)).init(allocator);

    while (lines.next()) |line| {
        var row = std.ArrayList(u8).init(allocator);
        try row.appendSlice(line);
        try arr.append(row);
    }

    var count: usize = 0;

    for (0..arr.items.len) |i| {
        const row = arr.items[i].items;
        for (row, 0..row.len) |c, j| {
            if (c == 'X') {
                //forward
                if (j < row.len - 3 and std.mem.eql(u8, "XMAS", row[j .. j + 4]))
                    count += 1;

                //backward
                if (j > 2 and std.mem.eql(u8, "SAMX", row[j - 3 .. j + 1]))
                    count += 1;

                var word = std.ArrayList(u8).init(allocator);

                // vertical down
                if (i < arr.items.len - 3) {
                    for (0..4) |k|
                        try word.append(arr.items[i + k].items[j]);

                    if (std.mem.eql(u8, "XMAS", word.items))
                        count += 1;
                }

                word.clearAndFree();

                //vertical up
                if (i > 2) {
                    for (0..4) |k| {
                        try word.append(arr.items[i - k].items[j]);
                    }
                    if (std.mem.eql(u8, "XMAS", word.items))
                        count += 1;
                }

                word.clearAndFree();

                // vertical upper right diagonal
                if (i > 2 and j < row.len - 3) {
                    for (0..4) |k| {
                        try word.append(arr.items[i - k].items[j + k]);
                    }

                    if (std.mem.eql(u8, "XMAS", word.items))
                        count += 1;
                }

                word.clearAndFree();

                // vertical upper left diagonal
                if (i > 2 and j > 2) {
                    for (0..4) |k| {
                        try word.append(arr.items[i - k].items[j - k]);
                    }
                    if (std.mem.eql(u8, "XMAS", word.items))
                        count += 1;
                }

                word.clearAndFree();

                // vertical down right diagonal
                if (i < arr.items.len - 3 and j < row.len - 3) {
                    for (0..4) |k| {
                        try word.append(arr.items[i + k].items[j + k]);
                    }
                    if (std.mem.eql(u8, "XMAS", word.items))
                        count += 1;
                }

                word.clearAndFree();

                // vertical down left diagonal
                if (i < arr.items.len - 3 and j > 2) {
                    for (0..4) |k| {
                        try word.append(arr.items[i + k].items[j - k]);
                    }
                    if (std.mem.eql(u8, "XMAS", word.items))
                        count += 1;
                }

                word.clearAndFree();
            }
        }
    }
    std.debug.print("{d}\n", .{count});
}
