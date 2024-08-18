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
testing 95 different build targets.

See [Actions](https://github.com/upx/upx-test-build-with-zig/actions)
for actual build results and logs.

And visit https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html
for some background info about `zig cc`.


Noteworthy open zig issues
==========================

- https://github.com/ziglang/zig/issues/10989 pthread.h not found for target x86_64-windows-gnu
  - **MAJOR BLOCKER**: this means that Windows currently cannot use multi-threading
  - alternative: `llvm-mingw` from https://github.com/mstorsjo/llvm-mingw
- https://github.com/ziglang/zig/issues/10411
- https://github.com/ziglang/zig/issues/13437
- https://github.com/ziglang/zig/issues/20376
- https://github.com/ziglang/zig/issues/20690 RFC/Proposal: Turning Zig target triples into quadruples


Noteworthy changes that did improve 'zig cc'
============================================

- 2022-11-17 https://github.com/ziglang/zig/commit/88a0f3d windows: fix _tls_index
- 2022-12-28 https://github.com/ziglang/zig/commit/7350f0d mingw: add missing vscprintf.c file
- 2022-12-28 https://github.com/ziglang/zig/commit/34887cf powerpc does not have a red zone
  - TODO: this seems **WRONG** (but is probably harmless):
    - see https://github.com/torvalds/linux/commit/573ebfa6601f
    - see https://github.com/llvm/llvm-project/commit/660b0d7f7bba
- 2023-01-21 https://github.com/ziglang/zig/pull/14397
    - closes https://github.com/ziglang/zig/issues/12992 zig c++ does not support exceptions on macos
- 2023-01-22 https://github.com/ziglang/zig/commit/aa626de
- 2023-01-22 https://github.com/ziglang/zig/commit/8484df5 zig cc: add -Wno-overriding-t-option to clang on darwin
- 2023-07-21 https://github.com/ziglang/zig/commit/8a18abf Remove the SingleThread limitation for ARM
    - closes https://github.com/ziglang/zig/issues/6573


Other noteworthy changes
========================

- older Windows versions (XP and Vista)
  - 2023-10-02 https://github.com/ziglang/zig/commit/15ce965 define _WIN32_WINNT based on target
    - INFO: this reveals that libunwind cannot be compiled for XP and Vista (i386 only)
      - libunwind needs `AcquireSRWLockShared()` (>= Windows Vista aka Windows 6)
      - on i386 libunwind also needs `EnumProcessModules()` from PSABI_VERSION 2, i.e >= Windows 7
  - 2024-01-xx: zig now targets `ucrt` instead of `msvcrt`, so Windows 7 is required anyway
    - TODO: is this really true?


Closed zig issues
=================

- https://github.com/ziglang/zig/issues/6573
- https://github.com/ziglang/zig/issues/12886
- https://github.com/ziglang/zig/issues/12992 zig c++ does not support exceptions on macos
- https://github.com/ziglang/zig/issues/13384 zig cc -target <arch>-windows-gnu produces a large amount of warnings
- https://github.com/ziglang/zig/issues/13385
- https://github.com/ziglang/zig/issues/17928 zig cc -c -fPIE stopped working
- https://github.com/ziglang/zig/issues/18009 zig cc -c -fstack-protector stopped working
- https://github.com/ziglang/zig/issues/18690 zig cc -target x86_64-windows.win7-gnu stopped working
- https://github.com/ziglang/zig/issues/19206 zig cc -target x86_64-macos-none stopped working
- https://github.com/ziglang/zig/pull/19385 Improve old glibc versions
