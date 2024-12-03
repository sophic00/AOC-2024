const std = @import("std");
const Allocator = std.mem.Allocator;
const fs = std.fs;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try fs.cwd().openFile("input3", .{});
    defer input.close();

    const size = try input.getEndPos();
    const buffer = try allocator.alloc(u8, size);
    defer allocator.free(buffer);

    _ = try input.readAll(buffer);

    var i: usize = 0;
    var sum: i64 = 0;
    var do = true;
    while (i < buffer.len) : (i += 1) {
        const remaining = buffer.len - i;

        if (remaining >= 3 and std.mem.eql(u8, buffer[i .. i + 3], "do(")) {
            do = true;
            while (i < buffer.len and buffer[i] != ')') : (i += 1) {}
            continue;
        }

        if (remaining >= 6 and std.mem.eql(u8, buffer[i .. i + 6], "don't(")) {
            do = false;
            while (i < buffer.len and buffer[i] != ')') : (i += 1) {}
            continue;
        }

        if (remaining >= 4 and std.mem.eql(u8, buffer[i .. i + 4], "mul(") and do) {
            var j = i + 4;
            while (j < buffer.len and buffer[j] != ',')
                j += 1;
            if ((j - i) > 7)
                continue;
            const num1 = std.fmt.parseInt(i64, buffer[i + 4 .. j], 10) catch continue;

            var k = j + 1;
            while (k < buffer.len and buffer[k] != ')')
                k += 1;

            const num2 = std.fmt.parseInt(i64, buffer[j + 1 .. k], 10) catch continue;
            sum += num1 * num2;
            i = k;
        }
    }

    std.debug.print("{d}\n", .{sum});
}
