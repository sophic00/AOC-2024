const std = @import("std");
const Allocator = std.mem.Allocator;
const pow = std.math.pow;
const fs = std.fs;

fn isSafe(arr: []i32) bool {
    const n = arr.len;
    var asc = false;
    var diff: u64 = 0;
    for (0..n) |i| {
        if (i == 0)
            asc = arr[i] < arr[i + 1];

        if (i == n - 1) {
            if (asc != (arr[i - 1] < arr[i]))
                return false;

            diff = @abs(arr[i] - arr[i - 1]);
            if (diff < 1 or diff > 3)
                return false;

            continue;
        }

        diff = @abs(arr[i] - arr[i + 1]);
        if (diff < 1 or diff > 3 or (asc != (arr[i] < arr[i + 1])))
            return false;
    }
    return true;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try fs.cwd().openFile("input2", .{});
    defer input.close();

    const size = try input.getEndPos();
    const buffer = try allocator.alloc(u8, size);
    defer allocator.free(buffer);

    _ = try input.readAll(buffer);

    var lines = std.mem.tokenizeAny(u8, buffer, "\n");
    var arr = std.ArrayList(i32).init(allocator);
    var safe: u64 = 0;
    while (lines.next()) |line| {
        var nums = std.mem.tokenizeAny(u8, line, " ");
        while (nums.next()) |num| {
            try arr.append(try std.fmt.parseInt(i32, num, 10));
        }

        if (isSafe(arr.items))
            safe += 1;
        arr.clearAndFree();
    }
    std.debug.print("{d}\n", .{safe});
}
