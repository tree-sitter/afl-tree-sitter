TS_JAVASCRIPT_DIR=vendor/tree-sitter-javascript/src
TS_IDIR=vendor/tree-sitter/src
TS_DIR=$(TS_IDIR)/runtime
UTF8_IDIR=vendor/tree-sitter/externals/utf8proc

IDIR=vendor/tree-sitter/include
CC=clang
CFLAGS=-I$(IDIR) -I$(TS_IDIR) -I$(UTF8_IDIR)

ODIR=.

# _DEPS = tree-sitter/runtime.h tree-sitter/parser.h
# DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_TS_OBJ = document.c error_costs.c language.c lexer.c node.c parser.c stack.c string_input.c tree.c utf16.c
TS_OBJ = $(patsubst %,$(TS_DIR)/%,$(_TS_OBJ))

_OBJ = $(TS_JAVASCRIPT_DIR)/scanner.c $(TS_JAVASCRIPT_DIR)/parser.c afl.c
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

# $(ODIR)/%.o: %.c $(DEPS)
# 	$(CC) -c -o $@ $< $(CFLAGS)

afl: $(UTF8_IDIR)/utf8proc.c $(TS_OBJ) $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*~
