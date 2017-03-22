afl fuzzing for tree-sitter

## Getting started

1. Run `script/bootstrap` to get setup. This will run `make` to build tree-sitter and the tree-sitter afl test harness with `afl-clang`.
1. Run `script/setup-ramdisk` to get a RAM disk setup and copy over the afl inputs.
1. Run `afl-fuzz -d -i afl_in -o afl_out ./afl @@` from your RAM disk.

## Run parallel

You can fuz in parallel to take full advantage of multi-core systems. (NOTE: This helps, but macOS still has some known performance issues.)

``` sh
# master
# 1s timeout
# Use JavaScript dictionary
afl-fuzz -i afl_in -o afl_out -M master -t 1000 -x /usr/local/Cellar/afl-fuzz/2.39b/share/afl/js.dict ./afl @@

# secondaries
afl-fuzz -i afl_in -o afl_out -S secondary1 -t 1000 -x /usr/local/Cellar/afl-fuzz/2.39b/share/afl/js.dict ./afl @@
afl-fuzz -i afl_in -o afl_out -S secondary2 -t 1000 -x /usr/local/Cellar/afl-fuzz/2.39b/share/afl/js.dict ./afl @@
```
