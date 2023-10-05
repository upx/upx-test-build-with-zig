                 ooooo     ooo  ooooooooo.  ooooooo  ooooo
                 `888'     `8'  `888   `Y88. `8888    d8'
                  888       8    888   .d88'   Y888..8P
                  888       8    888ooo88P'     `8888'
                  888       8    888           .8PY888.
                  `88.    .8'    888          d8'  `888b
                    `YbodP'     o888o       o888o  o88888o


                    The Ultimate Packer for eXecutables
                           https://upx.github.io


Test building UPX with 'zig cc'
===============================

This repository consists of a single
[GitHub Actions workflow file](.github/workflows/build-upx-with-zig.yml)
that builds
[UPX](https://github.com/upx/upx) with a recent
[Zig binary](https://ziglang.org/download/)
testing 104 different build targets.

See [Actions](https://github.com/upx/upx-test-build-with-zig/actions)
for actual build results and logs.

And visit https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html
for some background info about `zig cc`.

Regressions
===========

- 2023-06-11: 0.11.0-dev.3395+1e7dcaa3a
  - mips64-linux-gnuabin32 and mips64el-linux-gnuabin32 stopped working

Noteworthy zig issues
=====================

- https://github.com/ziglang/zig/issues/13385


Noteworthy changes that improve 'zig cc'
========================================

- 2022-11-17 https://github.com/ziglang/zig/commit/88a0f3d windows: fix _tls_index
- 2022-12-28 https://github.com/ziglang/zig/commit/7350f0d mingw: add missing vscprintf.c file
- 2022-12-28 https://github.com/ziglang/zig/commit/34887cf powerpc does not have a red zone
  - TODO: but this seems **WRONG**:
    - see https://github.com/torvalds/linux/commit/573ebfa6601f
    - see https://github.com/llvm/llvm-project/commit/660b0d7f7bba
- 2023-01-21 https://github.com/ziglang/zig/pull/14397
    - closes https://github.com/ziglang/zig/issues/12992 zig c++ does not support exceptions on macos
- 2023-01-22 https://github.com/ziglang/zig/commit/aa626de
- 2023-01-22 https://github.com/ziglang/zig/commit/8484df5 zig cc: add -Wno-overriding-t-option to clang on darwin
- 2023-07-21 https://github.com/ziglang/zig/commit/8a18abf Remove the SingleThread limitation for ARM
    - closes https://github.com/ziglang/zig/issues/6573
- 2023-10-02 https://github.com/ziglang/zig/commit/15ce965 define _WIN32_WINNT based on target
  - TODO: reveals that libunwind cannot be compiled for XP and Vista (i386 only)
    - libunwind needs AcquireSRWLockShared() (>= Windows Vista aka Windows 6)
    - on i386 libunwind also needs EnumProcessModules() (from PSABI_VERSION 2, i.e >= Windows 7)

Closed zig issues
=================

- https://github.com/ziglang/zig/issues/6573
- https://github.com/ziglang/zig/issues/12886
- https://github.com/ziglang/zig/issues/12992
- https://github.com/ziglang/zig/issues/13384 zig cc -target <arch>-windows-gnu produces a large amount of warnings
