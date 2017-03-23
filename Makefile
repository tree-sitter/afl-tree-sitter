export AFL_HARDEN=1

TS_IDIR=vendor/tree-sitter/src
TS_DIR=$(TS_IDIR)/runtime
UTF8_IDIR=vendor/tree-sitter/externals/utf8proc

IDIR=vendor/tree-sitter/include
CC=afl-clang
CXX=afl-clang++
CFLAGS=-Wall -I. -I$(IDIR) -I$(UTF8_IDIR) -I$(TS_IDIR)

# tree-sitter runtime
SRC_FILES = $(UTF8_IDIR)/utf8proc.c
SRC_FILES += $(wildcard $(TS_DIR)/*.c)

# afl test harness
SRC_FILES += afl.c

# tree-sitter-javascript parser
TS_JAVASCRIPT_C_FILES := $(SRC_FILES)
TS_JAVASCRIPT_C_FILES += vendor/tree-sitter-javascript/src/parser.c
TS_JAVASCRIPT_C_FILES += vendor/tree-sitter-javascript/src/scanner.c
TS_JAVASCRIPT_OBJ_FILES = $(addprefix obj/, $(TS_JAVASCRIPT_C_FILES:.c=.o))

# tree-sitter-ruby parser
TS_RUBY_C_FILES := $(SRC_FILES)
TS_RUBY_C_FILES += vendor/tree-sitter-ruby/src/parser.c
TS_RUBY_CXX_FILES = vendor/tree-sitter-ruby/src/scanner.cc
TS_RUBY_OBJ_FILES  = $(addprefix obj/, $(TS_RUBY_C_FILES:.c=.o))
TS_RUBY_OBJ_FILES += $(addprefix obj/, $(TS_RUBY_CXX_FILES:.cc=.o))

all: afl-ruby afl-javascript

afl-ruby: $(TS_RUBY_OBJ_FILES) afl_ruby.c
	$(CC) -o $@ $^ $(CFLAGS) -lstdc++

afl-javascript: $(TS_JAVASCRIPT_OBJ_FILES) afl_javascript.c
	$(CC) -o $@ $^ $(CFLAGS)

obj/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS)

obj/%.o: %.cc
	@mkdir -p $(dir $@)
	$(CXX) -c -o $@ $< $(CFLAGS)

docker-image:
	docker build -t afl-tree-sitter .

docker-run:
	docker run -v $(CURDIR):/var/local/afl-tree-sitter -w /var/local/afl-tree-sitter -t afl-tree-sitter make clean && make
	docker run -v /Volumes/RAM\ Disk/:/var/local/afl-tree-sitter -w /var/local/afl-tree-sitter -i -t afl-tree-sitter fuzz

.PHONY: all clean

clean:
	rm -f afl-javascript
	rm -f afl-ruby
	rm -rf obj
