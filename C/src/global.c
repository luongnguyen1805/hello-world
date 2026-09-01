
#include <stdio.h>
#include <stdlib.h>

#include <mach-o/dyld.h>
#include <limits.h>
#include <string.h>
#include <libgen.h>

int get_executable_dir(char *out, size_t size) {

    char path[PATH_MAX];
    uint32_t bufsize = sizeof(path);

    if (_NSGetExecutablePath(path, &bufsize) != 0) {
        return -1;
    }

    char resolved[PATH_MAX];
    if (realpath(path, resolved)) {
        strcpy(path, resolved);
    }

    // Find last '/'
    char *slash = strrchr(path, '/');
    if (!slash) {
        return -1;
    }

    *slash = '\0';  // truncate filename

    if (strlen(path) + 1 > size) {
        return -1;
    }

    strcpy(out, path);
    return 0;
}

void action1() {
    printf("\n...Action...");
}

void action2() {
    char dir[1024];
    if (get_executable_dir(dir, sizeof(dir)) == 0) {
        printf("\nExecutable directory: %s", dir);
    } else {
        printf("\nUnknown Executable directory");
    }
}