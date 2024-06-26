const builtin = @import("builtin");
const std = @import("std");
const float = @import("float");

fn mean(comptime T: type, arr: []const T) T {
     if (arr.len == 0) {
         return 0.0;
     }

     var sum: T = 0.0;
     for (arr) |value| {
         sum += value;
     }
     const fsum: T = @floatCast(sum);
     const flen: T = @floatFromInt(arr.len);
     return fsum / flen;
 }

fn median(comptime T: type, arr: []const T) ?T {
    if (arr.len == 0) return null;

    var sorted_arr = std.heap.page_allocator.dupe(T, arr) catch return null;
    defer std.heap.page_allocator.free(sorted_arr);

    // Sort the array
    std.sort.insertion(T, sorted_arr[0..], {}, std.sort.asc(T));

    const mid = arr.len / 2;

    // If the array length is odd, return the middle element
    // If the array length is even, return the average of the two middle elements
    if (arr.len % 2 == 0) {
        return (sorted_arr[mid - 1] + sorted_arr[mid]) / 2;
    } else {
        return sorted_arr[mid];
    }
}
fn mode(comptime T: type, arr: []const T) ?T {
    if (arr.len == 0) return null;

    var frequency_map = std.AutoHashMap(T, usize).init(std.heap.page_allocator);

    defer frequency_map.deinit();

    var max_freq: usize = 0;
    var mode_value: ?T = null;

    for (arr) |value| {
        const entry = frequency_map.get(value);
        var freq: usize = 1;
        if (entry) |existing_freq| {
            freq = existing_freq + 1;
        }
        frequency_map.put(value, freq) catch {
            return null; // Handle allocation failure
        };

        if (freq > max_freq) {
            max_freq = freq;
            mode_value = value;
        }
    }

    return mode_value;
}

fn range(comptime T: type, arr: []const T) ?T {
    if (arr.len == 0) return null;

    var min_value: T = arr[0];
    var max_value: T = arr[0];

    for (arr) |value| {
        if (value < min_value) {
            min_value = value;
        }
        if (value > max_value) {
            max_value = value;
        }
    }

    return max_value - min_value;
}

pub fn main() void {
    const data_f32 = [_]f32{ 1.0, 2.0, 3.0, 4.0, 5.0, 7.0 };
    const data_f64 = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 7.0 };

    const mean_f32 = mean(f32, data_f32[0..]);
    const mean_f64 = mean(f64, data_f64[0..]);

    //const mode_f32 = mode(f32, data_f32[0..]);
    //const mode_f64 = mode(f64, data_f64[0..]);

    const median_f32 = median(f32, data_f32[0..]);
    const median_f64 = median(f64, data_f64[0..]);

    const range_f32 = range(f32, data_f32[0..]);
    const range_f64 = range(f64, data_f64[0..]);

    std.debug.print("Mean (f32): {}\n", .{mean_f32});
    std.debug.print("Mean (f64): {}\n", .{mean_f64});
    //std.debug.print("Mode (f32): {}\n", .{mode_f32 orelse -1});
    //std.debug.print("Mode (f64): {}\n", .{mode_f64 orelse -1});
    std.debug.print("Median (f32): {}\n", .{median_f32 orelse -1});
    std.debug.print("Median (f64): {}\n", .{median_f64 orelse -1});
    std.debug.print("Range (f32): {}\n", .{range_f32 orelse -1});
    std.debug.print("Range (f64): {}\n", .{range_f64 orelse -1});
}

test "what are we testing today" {
    const data_f64 = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0 };
    const med = median(f64, data_f64[0..]);
    try std.testing.expectEqual(med, 3.0);
}
