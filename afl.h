#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <sys/stat.h>
#include <dirent.h>

#include "tree_sitter/runtime.h"

int parse_file(TSLanguage*, const char*);
int parse(int, char const *[], TSLanguage*);
