afl fuzzing for tree-sitter

## Getting started

1. Run `script/bootstrap` to get setup. This will run `make` to build tree-sitter and the tree-sitter afl test harness with `afl-clang`.
1. Run `script/setup-ramdisk` to get a RAM disk setup and copy over the afl inputs.
1. Run `afl-fuzz -d -i afl_in -o afl_out ./afl @@` from your RAM disk.
