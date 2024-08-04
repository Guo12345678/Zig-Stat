const builtin = @import("builtin");
const std = @import("std");
const float = @import("float");

const sqrt2pi = std.math.sqrt(2.0 * std.math.pi);

pub fn dnorm(x: f64, mean: f64, stddev: f64) f64 {
    const z = (x - mean) / stddev;
    return std.math.exp(-0.5 * z * z) / (stddev * sqrt2pi);
}

// Cumulative distribution function for a normal distribution (CDF)
pub fn pnorm(x: f64, mean: f64, stddev: f64) f64 {
    const z = (x - mean) / stddev;
    return 0.5 * (1.0 + erf(z / std.math.sqrt(2.0)));
}

fn erf(x: f64) f64 {
    // Coefficients for approximation to erf in the range [0, 0.84375]
    const p = [5]f64{ 2.54829592e-01, -2.84496736e-01, 1.421413741, -1.4533152027, 1.061405429 };

    const t = 1.0 / (1.0 + 0.3275911 * @abs(x));
    const tau = ((p[0] * t) + p[1] * std.math.pow(f64, t, 2) + p[2] * std.math.pow(f64, t, 3) + p[3] * std.math.pow(f64, t, 4) + p[4] * std.math.pow(f64, t, 5)) * std.math.exp(-1.0 * std.math.pow(f64, x, 2));
    const res = 1.0 - tau;
    return if (x >= 0) res else -res;
}

pub fn rnorm(mean: f64, stddev: f64) f64 {
    const rGen = std.rand.DefaultPrng;
    var rnd = rGen.init(0);
    const num1 = rnd.random().float(f64);
    const num2 = rnd.random().float(f64);

    // Use Box-Muller transform to get two independent standard normal variates
    const z0 = std.math.sqrt(-2.0 * @log(num1)) * std.math.cos(2.0 * std.math.pi * num2);

    // Transform the standard normal variate to desired mean and standard deviation
    return mean + z0 * stddev;
}

test "dnormTest" {
    const med = dnorm(0.0, 0.0, 1.0);
    try std.testing.expectEqual(med, 0.3989423);
}
