TS_JAVASCRIPT_DIR=vendor/tree-sitter-javascript/src
TS_DIR=vendor/tree-sitter/src/runtime

IDIR=vendor/tree-sitter/include
LDIR=vendor/tree-sitter/out/Release
CC=clang
CFLAGS=-I$(IDIR) -L$(LDIR)

ODIR=.
LIBS=-lruntime

_DEPS = tree-sitter/runtime.h tree-sitter/parser.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJ = $(TS_JAVASCRIPT_DIR)/scanner.c $(TS_JAVASCRIPT_DIR)/parser.c afl.c
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

afl: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*~
