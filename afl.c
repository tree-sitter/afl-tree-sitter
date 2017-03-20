#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <sys/stat.h>
#include <dirent.h>

#include "tree_sitter/runtime.h"

TSLanguage *tree_sitter_javascript();

int parse_file_contents(char* file_contents) {
  printf("%s\n", file_contents);

  TSDocument *document = ts_document_new();
  ts_document_set_language(document, tree_sitter_javascript());
  // ts_document_set_input_string(document, "console.log('hi')");
  ts_document_set_input_string(document, file_contents);
  ts_document_parse(document);

  TSNode root_node = ts_document_root_node(document);

  printf("Syntax tree: %s\n", ts_node_string(root_node, document));
  ts_document_free(document);
  return 0;
}

int parse_file(const char* filename) {
  FILE *fp;
  struct stat filestatus;
  int file_size;
  char* file_contents;

  if ( stat(filename, &filestatus) != 0) {
    fprintf(stderr, "File %s not found\n", filename);
    return 1;
  }

  file_size = filestatus.st_size;
  file_contents = (char*)malloc(filestatus.st_size);
  if ( file_contents == NULL) {
    fprintf(stderr, "Memory error: unable to allocate %d bytes\n", file_size);
    return 1;
  }

  fp = fopen(filename, "rt");
  if (fp == NULL) {
    fprintf(stderr, "Unable to open %s\n", filename);
    fclose(fp);
    free(file_contents);
    return 1;
  }
  if ( fread(file_contents, file_size, 1, fp) != 1 ) {
    fprintf(stderr, "Unable t read content of %s\n", filename);
    fclose(fp);
    free(file_contents);
    return 1;
  }
  fclose(fp);

  parse_file_contents(file_contents);

  free(file_contents);
  return 0;
}

int parse_files_in_directory(char* test_dir) {
  DIR *d;
  struct dirent *dir;

  d = opendir(test_dir);
  if (d) {
    while ((dir = readdir(d)) != NULL) {
      if (dir->d_type == DT_REG) {
        printf("Parsing %s\n", dir->d_name);
        char *filename = malloc(strlen(test_dir) + strlen(dir->d_name) + 2);
        if (filename == NULL) {
          fprintf(stderr, "Unable to malloc filename for %s\n", dir->d_name);
          return 1;
        }
        sprintf(filename, "%s/%s", test_dir, dir->d_name);
        parse_file(filename);
        free(filename);
      }

    }
    closedir(d);
    return 0;
  } else {
    fprintf(stderr, "Unable to open directory %s\n", test_dir);
    return 1;
  }

}

int main(int argc, char const *argv[]) {
  if (argc == 2) {
    printf("tree-sitter-javascript language version: %d\n", ts_language_version(tree_sitter_javascript()));
    // parse_files_in_directory("afl_in");
    return parse_file(argv[1]);
  }
  else {
    fprintf(stderr, "ERROR. Must pass one file path to parse.\nusage: afl FILE\n\n       afl-fuzz -i afl_in -o afl_out ./afl @@\n");
    return 1;
  }
}
