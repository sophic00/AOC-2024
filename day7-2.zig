const std = @import("std");
const Allocator = std.mem.Allocator;
const fs = std.fs;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try fs.cwd().openFile("input7", .{});
    defer input.close();

    const size = try input.getEndPos();
    const buffer = try allocator.alloc(u8, size);
    defer allocator.free(buffer);

    _ = try input.readAll(buffer);

    var lines = std.mem.tokenizeAny(u8, buffer, "\n");
    var count: u64 = 0;
    while (lines.next()) |line| {
        var obj = std.mem.tokenizeAny(u8, line, ":");
        const target = std.fmt.parseInt(u64, obj.next() orelse "", 10) catch continue;
        var vals = std.mem.tokenizeAny(u8, obj.next() orelse "", " ");
        var nums = std.ArrayList(u64).init(allocator);
        while (vals.next()) |val| {
            const num = std.fmt.parseInt(u64, val, 10) catch continue;
            try nums.append(num);
        }
        const ans = compute(nums.items, target, allocator);
        if (ans)
            count += target;
    }

    std.debug.print("{d}\n", .{count});
}

fn compute(values: []u64, target: u64, allocator: Allocator) bool {
    var i: u64 = 0;
    const n: u64 = values.len - 1;
    const total = std.math.pow(u64, 3, n);
    while (i < total) : (i += 1) {
        var vals = std.ArrayList(u64).init(allocator);
        defer vals.deinit();
        vals.appendSlice(values) catch continue;
        var nums = vals.items;
        var j: u64 = 0;
        var k = i;
        while (j < n) : (j += 1) {
            const op = k % 3;
            k = k / 3;
            switch (op) {
                0 => {
                    nums[j + 1] = nums[j] + nums[j + 1];
                },
                1 => {
                    nums[j + 1] = nums[j] * nums[j + 1];
                },
                else => {
                    const buf = std.fmt.allocPrint(allocator, "{d}{d}", .{ nums[j], nums[j + 1] }) catch continue;
                    nums[j + 1] = std.fmt.parseInt(u64, buf, 10) catch continue;
                },
            }
        }
        if (nums[n] == target)
            return true;
    }
    return false;
}
