# Zig-Stat-Lib

A basic statistics library for the zig language

## Add to your project

Run `zig fetch --save https://github.com/Guo12345678/Zig-Stat/archive/refs/heads/main.zip`, then modify your `build.zig` as follows:

```zig
const zigstat = b.dependency("zigstat", .{
  .target = target,
  .optimize = optimize,
});

exe.root_module.addImport("zigstat", zigstat.module("zigstat"));
```

The library should now be available under `@import("zigstat")`.

## Running tests

```shell
zig run main.zig
```
