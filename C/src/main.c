
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/select.h>
#include <termios.h>

void showActions() {
    printf("1. Action 1\n");
    printf("2. Action 2\n");
    printf("0. Exit\n");
}

struct termios orig_termios;

void disable_raw_mode() {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
}

void enable_raw_mode() {
    tcgetattr(STDIN_FILENO, &orig_termios);
    atexit(disable_raw_mode);  // Restore terminal on exit

    struct termios raw = orig_termios;
    raw.c_lflag &= ~(ICANON | ECHO); // Turn off line buffering and echo
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void set_nonblocking(int fd) {
    int flags = fcntl(fd, F_GETFL, 0);
    fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}

int main() {

    set_nonblocking(STDIN_FILENO);
    enable_raw_mode();

    int running = 1;
    char commandBuffer[100];
    
    showActions();

    while (running > 0) {
        
        fd_set readfds;
        FD_ZERO(&readfds);
        FD_SET(STDIN_FILENO, &readfds);

        struct timeval timeout = {1, 0}; // 1 second
        int ret = select(STDIN_FILENO + 1, &readfds, NULL, NULL, &timeout);

        if (ret > 0 && FD_ISSET(STDIN_FILENO, &readfds)) {
            char ch;
            int len = read(STDIN_FILENO, &ch, 1);
            if (len > 0) {
                if (ch == 10) {
                    if (strcmp(commandBuffer,"0\0")) {
                        break;
                    }
                }
                else if (ch == 127 || ch == 8) {
                    int bufferLen = strlen(commandBuffer);
                    if (bufferLen > 1) {
                        commandBuffer[bufferLen - 1] = '\0';                        
                    }
                }
                else if (ch >= 32 && ch <= 126) {
                    int bufferLen = strlen(commandBuffer);
                    commandBuffer[bufferLen] = ch;
                    commandBuffer[bufferLen + 1] = '\0';
                }
            }
        }
        
        printf("\033[2K\rEvent loop: %d | Type command: %s", running,commandBuffer);
        fflush(stdout);

        running++;
    }

    printf("\nExited.\n");
    return 0;
}