TS_JAVASCRIPT_DIR=vendor/tree-sitter-javascript/src
TS_IDIR=vendor/tree-sitter/src
TS_DIR=$(TS_IDIR)/runtime
UTF8_IDIR=vendor/tree-sitter/externals/utf8proc

IDIR=vendor/tree-sitter/include
CC=afl-clang
CFLAGS=-Wall -I$(IDIR) -I$(UTF8_IDIR) -I$(TS_IDIR)

# tree-sitter runtime
SRC_FILES = $(UTF8_IDIR)/utf8proc.c
SRC_FILES += $(wildcard $(TS_DIR)/*.c)

# tree-sitter javascript parser
SRC_FILES += $(TS_JAVASCRIPT_DIR)/scanner.c
SRC_FILES += $(TS_JAVASCRIPT_DIR)/parser.c

OBJ_FILES = $(addprefix obj/, $(SRC_FILES:.c=.o))

export AFL_HARDEN=1

afl: $(OBJ_FILES) afl.c
	$(CC) -o $@ $^ $(CFLAGS)

obj/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

clean:
	rm -f afl
	rm -rf obj
