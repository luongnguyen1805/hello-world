#include <iostream>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/select.h>

void showActionMenu() {
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

    int tick = 0;

    showActionMenu();

    while (true) {
        // Use select() to wait up to 0.1s for input
        fd_set readfds;
        FD_ZERO(&readfds);
        FD_SET(STDIN_FILENO, &readfds);

        struct timeval timeout = {1, 0}; // 0.1 seconds

        int ready = select(STDIN_FILENO + 1, &readfds, NULL, NULL, &timeout);

        if (ready > 0 && FD_ISSET(STDIN_FILENO, &readfds)) {
            char ch;
            ssize_t n = read(STDIN_FILENO, &ch, 1);
            if (n > 0) {
                if (ch == '0') break;
            }
        }

        // Do something in the loop
        std::cout << "\033[2K\rEvent Loop: " << tick++ << " | Type command: " << std::flush;
        usleep(100000); // simulate work
    }

    std::cout << "\nExited.\n";
    return 0;
}
