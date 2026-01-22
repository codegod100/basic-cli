const std = @import("std");

pub fn build(b: *std.Build) void {
    // For x64musl target (matching the platform targets section)
    const x64musl_target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .linux,
        .abi = .musl,
    });

    // Use ReleaseFast for smaller, faster libraries
    const optimize: std.builtin.OptimizeMode = .ReleaseFast;

    // Get the Roc dependency to access its builtins module
    const roc_dep = b.dependency("roc", .{
        .target = x64musl_target,
        .optimize = optimize,
    });

    // Get the builtins module from Roc
    const builtins_module = roc_dep.module("builtins");

    // Build the host library
    const host_lib = b.addLibrary(.{
        .name = "host",
        .linkage = .static,
        .root_module = b.createModule(.{
            .root_source_file = b.path("platform/host.zig"),
            .target = x64musl_target,
            .optimize = optimize,
            .strip = true,
            .pic = true, // Enable Position Independent Code for PIE compatibility
        }),
    });

    // Add the builtins module import
    host_lib.root_module.addImport("builtins", builtins_module);

    // Don't bundle compiler-rt in host libraries - roc_shim provides it
    host_lib.bundle_compiler_rt = false;

    // Install the library
    b.installArtifact(host_lib);

    // Create a step to copy to platform/targets/x64musl/
    const copy_step = b.addInstallArtifact(host_lib, .{
        .dest_dir = .{ .override = .{ .custom = "../platform/targets/x64musl" } },
    });

    // Add a "host" step that builds and copies the host library
    const host_step = b.step("host", "Build the host library for the platform");
    host_step.dependOn(&copy_step.step);
}
