TS_JAVASCRIPT_DIR=vendor/tree-sitter-javascript/src
TS_IDIR=vendor/tree-sitter/src
TS_DIR=$(TS_IDIR)/runtime
UTF8_IDIR=vendor/tree-sitter/externals/utf8proc

IDIR=vendor/tree-sitter/include
CC=clang
CFLAGS=-Wall -I$(IDIR) -I$(UTF8_IDIR) -I$(TS_IDIR)

# _DEPS = tree-sitter/runtime.h tree-sitter/parser.h
# DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))
TS_FILES := $(wildcard $(TS_DIR)/*.c)
TS_OBJ := $(addprefix obj/tree-sitter/,$(notdir $(TS_FILES:.c=.o)))

afl: obj/utf8proc/utf8proc.o $(TS_OBJ) obj/tree-sitter-javascript/scanner.o obj/tree-sitter-javascript/parser.o obj/afl.o
	$(CC) -o $@ $^ $(CFLAGS) -v

obj/afl.o: afl.c
	$(CC) -c -o $@ $< $(CFLAGS)

obj/tree-sitter-javascript/scanner.o: $(TS_JAVASCRIPT_DIR)/scanner.c
	$(CC) -c -o $@ $< $(CFLAGS)
obj/tree-sitter-javascript/parser.o: $(TS_JAVASCRIPT_DIR)/parser.c
	$(CC) -c -o $@ $< $(CFLAGS)

obj/tree-sitter/%.o: $(TS_DIR)/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

obj/utf8proc/%.o: $(UTF8_IDIR)/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

obj:
	mkdir -p $@
	mkdir -p $@/utf8proc
	mkdir -p $@/tree-sitter
	mkdir -p $@/tree-sitter-javascript

.PHONY: clean

clean:
	rm -f afl obj/*.o obj/**/*.o
