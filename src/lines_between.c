#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

bool is_an_int(char *arg);

int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        fprintf(stderr, "Usage: %s N1 N2 [FILE]", argv[0]);
        return EXIT_FAILURE;
    }
    char* arg_N1 = argv[1];
    char* arg_N2 = argv[2];
    char* arg_FILE = NULL;
    if(argc == 4) arg_FILE = argv[3];
    if(!is_an_int(arg_N1) || !is_an_int(arg_N2)) {
        fprintf(stderr, "N1 and N2 must be integers.");
        return EXIT_FAILURE;
    }
    int N1 = atoi(arg_N1);
    int N2 = atoi(arg_N2);
    if(N1 <= 0 || N2 < N1) {
        fprintf(stderr, "N1 must be > 0 and N2 >= N1.");
        return EXIT_FAILURE;
    }

    FILE* output = stdin;
    if(arg_FILE != NULL) {
        output = fopen(arg_FILE, "r");
        if(output == NULL) {
            perror("Opening FILE.");
        }
    }

    char vl;

    int line_counter = 1;
    while(!feof(output)) {
        fread(&vl, 1, sizeof(char), output);
        if(ferror(output)) {
            perror("fread");
            return EXIT_FAILURE;
        }
        if(N1 <= line_counter && line_counter <= N2) {
            fwrite(&vl, 1, sizeof(char), stdout);
        }
        if(vl == '\n') {
            line_counter++;
        }
    }

    return EXIT_SUCCESS;
}

bool is_an_int(char *arg) {
    int res = atoi(arg);
    if(res == 0 && strcmp(arg, "0") != 0) {
        return false;
    }
    return true;
}