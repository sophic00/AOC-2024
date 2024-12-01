const std = @import("std");
const Allocator = std.mem.Allocator;
const pow = std.math.pow;
const fs = std.fs;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try fs.cwd().openFile("input1-1", .{});
    defer input.close();

    const size = try input.getEndPos();
    const buffer = try allocator.alloc(u8, size);
    defer allocator.free(buffer);

    _ = try input.readAll(buffer);
    var sum: i64 = 0;
    var num: i64 = 0;
    var i: usize = 0;
    var j: usize = 0;
    var arr1: [1000]i64 = undefined;
    var arr2: [1000]i64 = undefined;

    for (buffer) |c| {
        if (c == ' ') {
            if (num != 0) {
                arr1[i] = num;
                num = 0;
                i += 1;
            }
            continue;
        }

        if (c == '\n') {
            arr2[j] = num;
            num = 0;
            j += 1;
            continue;
        }

        num *= 10;
        num += c - '0';
    }

    sort(&arr1);
    sort(&arr2);

    for (0..1000) |x| {
        num = (arr1[x] - arr2[x]);
        sum += (if (num >= 0) num else -num);
    }
    std.debug.print("{d}\n", .{sum});
}

pub fn sort(arr: []i64) void {
    if (arr.len <= 1) return;
    quickSort(arr, 0, @intCast(arr.len - 1));
}

fn quickSort(arr: []i64, low: usize, high: usize) void {
    if (low >= high) return;

    const pivot = partition(arr, low, high);

    if (pivot > 0) {
        quickSort(arr, low, pivot - 1);
    }
    quickSort(arr, pivot + 1, high);
}

fn partition(arr: []i64, low: usize, high: usize) usize {
    const pivot = arr[high];
    var i: usize = low;

    var j: usize = low;
    while (j < high) : (j += 1) {
        if (arr[j] <= pivot) {
            const temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
            i += 1;
        }
    }

    const temp = arr[i];
    arr[i] = arr[high];
    arr[high] = temp;
    return i;
}
