#include "afl.h"

TSLanguage *tree_sitter_ruby();

int main(int argc, char const *argv[]) {
  parse(argc, argv, tree_sitter_ruby());
}
