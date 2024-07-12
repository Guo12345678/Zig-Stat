const builtin = @import("builtin");
const std = @import("std");
const float = @import("float");
pub const set = @import("setMath.zig");
pub const ran = @import("randomVariables.zig");

pub fn main() void {
    const data_f32 = [_]f32{ 1.0, 2.5, 3.0, 4.0, 5.0, 7.0 };
    const data_f64 = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 7.0 };

    const mean_f32 = set.mean(f32, data_f32[0..]);
    const mean_f64 = set.mean(f64, data_f64[0..]);

    //const mode_f32 = mode(f32, data_f32[0..]);
    //const mode_f64 = mode(f64, data_f64[0..]);

    const IQR_32 = set.IQR(f32, data_f32[0..]);
    const IQR_64 = set.IQR(f64, data_f64[0..]);

    const median_f32 = set.median(f32, data_f32[0..]);
    const median_f64 = set.median(f64, data_f64[0..]);

    const range_f32 = set.range(f32, data_f32[0..]);
    const range_f64 = set.range(f64, data_f64[0..]);

    const dens = ran.dnorm(0.0, 0.0, 1.0);
    const cdf = ran.pnorm(0.0, 0.0, 1.0);

    std.debug.print("Mean (f32): {}\n", .{mean_f32});
    std.debug.print("Mean (f64): {}\n", .{mean_f64});
    //std.debug.print("Mode (f32): {}\n", .{mode_f32 orelse -1});
    //std.debug.print("Mode (f64): {}\n", .{mode_f64 orelse -1});
    std.debug.print("Median (f32): {}\n", .{median_f32 orelse -1});
    std.debug.print("Median (f64): {}\n", .{median_f64 orelse -1});
    std.debug.print("IQR (f32): {}\n", .{IQR_32 orelse -1});
    std.debug.print("IQR (f64): {}\n", .{IQR_64 orelse -1});
    std.debug.print("Range (f32): {}\n", .{range_f32 orelse -1});
    std.debug.print("Range (f64): {}\n", .{range_f64 orelse -1});
    std.debug.print("DNorm: {}\n", .{dens});
    std.debug.print("PNorm: {}\n", .{cdf});
}
