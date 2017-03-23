# afl-tree-sitter

[afl](http://lcamtuf.coredump.cx/afl/) fuzzing for tree-sitter.


### Overview

This project focuses on fuzzing the tree-sitter runtime and associated parsers for each language tree-sitter supports. It does this through a small set of test harnesses, which are C programs—one for each language—that take an input file and (try to) parse it. The test harness, tree-sitter, and the language parsers are all compiled with `afl-clang` and hardening, after which fuzzing is performed with `afl-fuzz`.

### Getting started

``` sh
script/bootstrap
script/setup-ramdisk # Optional, but recommended b/c afl is hard on SSDs.
cd /Volumes/RAM\ Disk/ && fuzz javascript
```

### Bugs found so far

An incomplete list of interesting bugs found using `afl-fuzz`.

#### tree-sitter runtime

- Handling of invalid UTF8 characters. Not checking return value of `utf8proc_iterate` which then sets a -1 `codepoint_ref` and causes the parser to hang. Fixed in  [tree-sitter/tree-sitter@f394a48](https://github.com/tree-sitter/tree-sitter/commit/f394a48c0b87fb05988480d1c526486651492949) and test added in  [tree-sitter/tree-sitter@7092d45](https://github.com/tree-sitter/tree-sitter/commit/7092d4522a8d8928d5540c1d33f1d7bcbc036a04).
- Infinite loop due to which stack versions are selected for halting. Fixed in [tree-sitter/tree-sitter@a94742a ](https://github.com/tree-sitter/tree-sitter/commit/a94742aed35624b9ccfea02b49a32ec82afa3578).

#### tree-sitter-ruby

- Infinite loop in external scanner if closing quote is never found due to failure to also check for EOF. Fixed in [tree-sitter/tree-sitter-ruby@d5ed995](https://github.com/tree-sitter/tree-sitter-ruby/commit/d5ed995b874152288337ad267f3b9d570bc10dde).

### Run parallel

You can fuzz in parallel to take full advantage of multi-core systems. See `script/fuzz` for specific options passed to `afl-fuzz` and for language setup.

``` sh
# master
afl-fuzz -i afl_in -o afl_out -M master -t 1000 ./afl @@

# secondaries
afl-fuzz -i afl_in -o afl_out -S secondary1 -t 1000 ./afl @@
afl-fuzz -i afl_in -o afl_out -S secondary2 -t 1000 ./afl @@
```
