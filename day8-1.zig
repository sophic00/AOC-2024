const std = @import("std");
const Allocator = std.mem.Allocator;
const fs = std.fs;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try fs.cwd().openFile("input8", .{});
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
            if (map[i][j] == '.')
                continue;
            const c = map[i][j];
            // var m: u64 = i;
            // var n: u64 = j;
            // //    for()
            // std.debug.print("{c}", .{map[i][j]});
        }
        std.debug.print("\n", .{});
    }

    // std.debug.print("{d}\n", .{count});
}
