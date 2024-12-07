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
    const total: u64 = @as(u64, 1) << @intCast(n);
    while (i < total) : (i += 1) {
        var vals = std.ArrayList(u64).init(allocator);
        vals.appendSlice(values) catch continue;
        var nums = vals.items;
        var j: u64 = 0;
        while (j < n) : (j += 1) {
            if ((i & (@as(u64, 1) << @intCast(j))) == 0) {
                nums[j + 1] = nums[j] + nums[j + 1];
            } else {
                nums[j + 1] = nums[j] * nums[j + 1];
            }
        }

        if (nums[n] == target)
            return true;
    }
    return false;
}
