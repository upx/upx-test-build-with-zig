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
testing 90 different build targets.

See [Actions](https://github.com/upx/upx-test-build-with-zig/actions)
for actual build results and logs.

And visit https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html
for some background info about `zig cc`.


Noteworthy open zig issues
==========================

- https://github.com/ziglang/zig/issues/6573  libc++ does not work on multi-threaded ARM yet
  - https://reviews.llvm.org/D75183
  - https://github.com/ziglang/zig/commit/3997828a6176


Noteworthy zig commits that improve 'zig cc'
============================================

- 2022-12-28 https://github.com/ziglang/zig/commit/7350f0d mingw: add missing vscprintf.c file
- 2022-12-28 https://github.com/ziglang/zig/commit/34887cf powerpc does not have a red zone
  - TODO: but this is **WRONG**:
    - see https://github.com/torvalds/linux/commit/573ebfa6601f
    - see https://github.com/llvm/llvm-project/commit/660b0d7f7bba
- 2023-01-21 https://github.com/ziglang/zig/pull/14397
    - closes https://github.com/ziglang/zig/issues/12992 zig c++ does not support exceptions on macos
- 2023-01-22 https://github.com/ziglang/zig/commit/aa626de
- 2023-01-22 https://github.com/ziglang/zig/commit/8484df5 zig cc: add -Wno-overriding-t-option to clang on darwin
