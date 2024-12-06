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
    var arr1: [3]u8 = undefined;
    var arr2: [3]u8 = undefined;

    for (1..arr.items.len - 1) |i| {
        const row = arr.items[i].items;
        for (row[1 .. row.len - 1], 1..row.len - 1) |c, j| {
            if (c == 'A') {
                for (0..3) |k|
                    arr1[k] = arr.items[i - 1 + k].items[j - 1 + k];

                for (0..3) |k|
                    arr2[k] = arr.items[i - 1 + k].items[j + 1 - k];

                const true1 = std.mem.eql(u8, "MAS", &arr1) or std.mem.eql(u8, "SAM", &arr1);
                const true2 = std.mem.eql(u8, "MAS", &arr2) or std.mem.eql(u8, "SAM", &arr2);

                if (true1 and true2)
                    count += 1;
            }
        }
    }
    std.debug.print("{d}\n", .{count});
}
