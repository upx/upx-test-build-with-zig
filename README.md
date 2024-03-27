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
testing 116 different build targets.

See [Actions](https://github.com/upx/upx-test-build-with-zig/actions)
for actual build results and logs.

And visit https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html
for some background info about `zig cc`.


Noteworthy open zig issues
==========================

- https://github.com/ziglang/zig/issues/10989 pthread.h not found for target x86_64-windows-gnu
  - this means that Windows currently cannot use multi-threading; **major blocker**
  - alternative: `llvm-mingw` from https://github.com/mstorsjo/llvm-mingw
- https://github.com/ziglang/zig/issues/13385
- TODO zig: libcxx should be upgraded from 17.0.0 to 17.0.6
- TODO zig: musl libc should be upgraded from 1.2.4 to 1.2.5


Noteworthy changes that did improve 'zig cc'
============================================

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


Other noteworthy changes
========================

- glibc issues
  - 2023-04-09: 0.11.0-dev.2470+c22a30ac9 glibc-2.7 and glibc-2.11 targets stopped working
    - 0.11.0-dev.2401+348751462 works
  - probably caused by llvm-15 => llvm-16 upgrade; have to check libc++
  - 2024-01-05 https://github.com/ziglang/zig/commit/c22d1c0 minimum required glibc is v2.17
  - 2024-01-xx: glibc-2.7 and glibc-2.11 work again
  - 2024-03-26: https://github.com/ziglang/zig/pull/19385 Improve old glibc versions

- mips64-linux-gnuabin32 and mips64el-linux-gnuabin32
  - 2023-06-11: 0.11.0-dev.3395+1e7dcaa3a mips64-linux-gnuabin32 and mips64el-linux-gnuabin32 stopped working
    - 0.11.0-dev.3301+230ea411f works
  - 2024-01-06: 0.12.0-dev.2059+42389cb9c now works again

- older Windows versions (XP and Vista)
  - 2023-10-02 https://github.com/ziglang/zig/commit/15ce965 define _WIN32_WINNT based on target
    - INFO: this reveals that libunwind cannot be compiled for XP and Vista (i386 only)
      - libunwind needs `AcquireSRWLockShared()` (>= Windows Vista aka Windows 6)
      - on i386 libunwind also needs `EnumProcessModules()` from PSABI_VERSION 2, i.e >= Windows 7
  - 2024-01-xx: zig now targets `ucrt` instead of `msvcrt`, so Windows 7 is required anyway
    - TODO: is this true?


Closed zig issues
=================

- https://github.com/ziglang/zig/issues/6573
- https://github.com/ziglang/zig/issues/12886
- https://github.com/ziglang/zig/issues/12992
- https://github.com/ziglang/zig/issues/13384 zig cc -target <arch>-windows-gnu produces a large amount of warnings
- https://github.com/ziglang/zig/issues/17928 zig cc -c -fPIE stopped working
- https://github.com/ziglang/zig/issues/18009 zig cc -c -fstack-protector stopped working
- https://github.com/ziglang/zig/issues/18690 zig cc -target x86_64-windows.win7-gnu stopped working
- https://github.com/ziglang/zig/issues/19206 zig cc -target x86_64-macos-none stopped working
