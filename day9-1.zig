const std = @import("std");
const Allocator = std.mem.Allocator;
const fs = std.fs;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try fs.cwd().openFile("input9", .{});
    defer input.close();

    const size = try input.getEndPos();
    const buffer = try allocator.alloc(u8, size);
    defer allocator.free(buffer);

    _ = try input.readAll(buffer);

    var lines = std.mem.tokenizeAny(u8, buffer, "\n");
    var arr = std.ArrayList(std.ArrayList(u8)).init(allocator);
    defer arr.deinit();

    var checksum: u64 = 0;
    var i: u64 = 0;
    var j: u64 = size - 1;
    while (i < j) {
        if (i % 2 == 0) {
            while () {}
        } else {}
    }

    std.debug.print("{d}\n", .{size});
}
