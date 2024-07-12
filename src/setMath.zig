const builtin = @import("builtin");
const std = @import("std");
const float = @import("float");

pub fn mean(comptime T: type, arr: []const T) T {
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

pub fn median(comptime T: type, arr: []const T) ?T {
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

pub fn IQR(comptime T:type,arr:[]const T) ?T{
    if(arr.len == 0) return null;
    var sorted_arr = std.heap.page_allocator.dupe(T, arr) catch return null;
    defer std.heap.page_allocator.free(sorted_arr);

    // Sort the array
    std.sort.insertion(T, sorted_arr[0..], {}, std.sort.asc(T));

    const mid = arr.len / 2;
    const lower_half = sorted_arr[0..mid];
    const upper_half = if (arr.len % 2 == 0) sorted_arr[mid..] else sorted_arr[mid+1..];

    const q1 = median(T, lower_half) orelse return null;
    const q3 = median(T, upper_half) orelse return null;

    return q3 - q1;
}

pub fn mode(comptime T: type, arr: []const T) ?T {
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



pub fn range(comptime T: type, arr: []const T) ?T {
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



test "what are we testing today" {
    const data_f64 = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0 };
    const med = median(f64, data_f64[0..]);
    try std.testing.expectEqual(med, 3.0);
}
