#include <iostream>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/select.h>
#include <string>
#include <time.h>

using namespace std;

void showActions() {
    printf("1. Action 1\n");
    printf("2. Action 2\n");
    printf("0. Exit\n");
}

struct termios orig_termios;

void disableRawMode() {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
}

void enableRawMode() {
    tcgetattr(STDIN_FILENO, &orig_termios);
    atexit(disableRawMode);

    struct termios raw = orig_termios;
    raw.c_lflag &= ~(ICANON | ECHO); // disable line buffering and echo
    raw.c_cc[VMIN] = 0;
    raw.c_cc[VTIME] = 0;
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

void setNonBlockingStdin() {
    int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK);
}

int main() {
    enableRawMode();
    setNonBlockingStdin();

    int running = 1;
    string commandBuffer = "";
    time_t lastTimestamp = time(NULL);

    showActions();

    while (running > 0) {
        
        fd_set readfds;
        FD_ZERO(&readfds);
        FD_SET(STDIN_FILENO, &readfds);

        struct timeval timeout = {0, 0};
        int ready = select(STDIN_FILENO + 1, &readfds, NULL, NULL, &timeout);

        if (ready > 0 && FD_ISSET(STDIN_FILENO, &readfds)) {
            char ch;
            ssize_t n = read(STDIN_FILENO, &ch, 1);
            if (n > 0) {
                if (ch == 10 || ch == 13) {
                    if (commandBuffer == "0") {
                        break;
                    }
                }
                else if (ch == 127 || ch == 8) {
                    if (!commandBuffer.empty()) {
                        commandBuffer.pop_back();                        
                    }
                }
                else if (ch >= 32 && ch <= 126) {
                    commandBuffer += ch;
                }

                std::cout << "\033[2K\rRun loop: " << running << " | Type command: " << commandBuffer << std::flush;
                fflush(stdout);
            }
        }

        time_t currentTimestamp = time(NULL);
        if (difftime(currentTimestamp,lastTimestamp) > 0) {
            std::cout << "\033[2K\rRun loop: " << running << " | Type command: " << commandBuffer << std::flush;
            fflush(stdout);

            running++;            
            lastTimestamp = currentTimestamp;
        }        
    }

    std::cout << "\nExited.\n";
    return 0;
}
