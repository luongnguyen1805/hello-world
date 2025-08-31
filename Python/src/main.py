import sys
import termios
import tty
import fcntl
import os
import select
import time

# --- Terminal handling ---
orig_term = None

def enable_raw_mode():
    global orig_term
    orig_term = termios.tcgetattr(sys.stdin)
    tty.setraw(sys.stdin)
    # make stdin non-blocking
    flags = fcntl.fcntl(sys.stdin, fcntl.F_GETFL)
    fcntl.fcntl(sys.stdin, fcntl.F_SETFL, flags | os.O_NONBLOCK)

def disable_raw_mode():
    if orig_term:
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, orig_term)

def showActions():
    print("1. Action 1\r")
    print("2. Action 2\r")
    print("0. Exit\r")

# --- Main loop ---
def main():
    enable_raw_mode()
    try:
        running = 1
        command_buffer = ""
        last_timestamp = time.time()

        showActions()

        while running > 0:
            # non-blocking check
            rlist, _, _ = select.select([sys.stdin], [], [], 0)
            if rlist:
                ch = sys.stdin.read(1)
                if ch:
                    code = ord(ch)
                    if code in (10, 13):  # Enter
                        if command_buffer == "0":
                            break
                    elif code in (127, 8):  # Backspace
                        if command_buffer:
                            command_buffer = command_buffer[:-1]
                    elif 32 <= code <= 126:  # Printable
                        command_buffer += ch

            # update display each second or after input
            now = time.time()
            if rlist or (now - last_timestamp >= 1):
                sys.stdout.write(f"\033[2K\rRun loop: {running} | Type command: {command_buffer}")
                sys.stdout.flush()

            # tick
            if now - last_timestamp >= 1:
                running += 1
                last_timestamp = now

        # on exit → print clean exit message
        sys.stdout.write("\n\rExited.")
        sys.stdout.flush()

    finally:
        disable_raw_mode()
        # ensure shell prompt is clean
        sys.stdout.write("\n")
        sys.stdout.flush()

if __name__ == "__main__":
    main()
