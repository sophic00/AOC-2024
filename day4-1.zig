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

    for (0..arr.items.len) |i| {
        const row = arr.items[i].items;
        for (row, 0..row.len) |c, j| {
            if (c == 'X') {
                //forward
                if (j < row.len - 3 and std.mem.eql(u8, "XMAS", row[j .. j + 4]))
                    std.debug.print("f {s}\n", .{row[j .. j + 4]});

                //backward
                if (j > 3 and std.mem.eql(u8, "SAMX", row[j - 4 .. j]))
                    std.debug.print("b {s}\n", .{row[j - 4 .. j]});

                var word = std.ArrayList(u8).init(allocator);

                // vertical down
                if (i < arr.items.len - 3) {
                    for (i..i + 4) |k|
                        try word.append(arr.items[k].items[j]);

                    if (std.mem.eql(u8, "XMAS", word.items))
                        std.debug.print("vd {s}\n", .{word.items});
                }

                word.clearAndFree();

                //vertical up
                if (i > 2) {
                    for (i - 3..i + 1) |k| {
                        try word.append(arr.items[k].items[j]);
                    }
                    if (std.mem.eql(u8, "SAMX", word.items))
                        std.debug.print("vu {s}\n", .{word.items});
                }

                word.clearAndFree();

                // vertical upper right diagonal

                // vertical upper left diagonal

                // vertical down right diagonal

                // vertical down left diagonal

            }
        }
    }
}
