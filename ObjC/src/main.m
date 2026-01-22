// main.m
#import <Foundation/Foundation.h>
#import <termios.h>
#import <unistd.h>
#import <fcntl.h>
#import <time.h>

#import "Global.h"

// --- Terminal handling ---
static struct termios origTerm;

static void enableRawMode(void) {
    tcgetattr(STDIN_FILENO, &origTerm);
    struct termios raw = origTerm;
    raw.c_lflag &= ~(ICANON | ECHO);  // disable canonical + echo
    raw.c_cc[VMIN]  = 0;
    raw.c_cc[VTIME] = 0;
    tcsetattr(STDIN_FILENO, TCSANOW, &raw);
}

static void disableRawMode(void) {
    tcsetattr(STDIN_FILENO, TCSANOW, &origTerm);
}

static void setNonBlockingStdin(void) {
    int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK);
}

static void showActions(void) {
    printf("1. Action 1\n");
    printf("2. Action 2\n");
    printf("0. Exit\n");
}

// --- Main ---
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        enableRawMode();
        setNonBlockingStdin();
        atexit(disableRawMode);

        int running = 1;
        NSMutableString *commandBuffer = [NSMutableString string];
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
                    if (ch == 10 || ch == 13) { // Enter

                        if ([commandBuffer isEqualToString:@"1"]) {
                            [[Global shared] action1];
                        }
                        else if ([commandBuffer isEqualToString:@"2"]) {
                            [[Global shared] action2];
                        }

                        break;
                        [commandBuffer setString:@""]; // clear buffer
                    }
                    else if (ch == 127 || ch == 8) { // Backspace
                        if (commandBuffer.length > 0) {
                            [commandBuffer deleteCharactersInRange:NSMakeRange(commandBuffer.length-1, 1)];
                        }
                    }
                    else if (ch >= 32 && ch <= 126) { // Printable
                        [commandBuffer appendFormat:@"%c", ch];
                    }

                    printf("\033[2K\rRun loop: %d | Type command: %s", running, [commandBuffer UTF8String]);
                    fflush(stdout);
                }
            }

            time_t currentTimestamp = time(NULL);
            if (difftime(currentTimestamp, lastTimestamp) > 0) {
                printf("\033[2K\rRun loop: %d | Type command: %s", running, [commandBuffer UTF8String]);
                fflush(stdout);

                running++;
                lastTimestamp = currentTimestamp;
            }
        }

        printf("\nExited.\n");
    }
    return 0;
}
