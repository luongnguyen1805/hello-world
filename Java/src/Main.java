
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import com.sun.jna.*;
import com.sun.jna.ptr.*;

public class Main {

    public interface CLibrary extends Library {

        public static class Termios extends Structure {
            public NativeLong c_iflag;
            public NativeLong c_oflag;
            public NativeLong c_cflag;
            public NativeLong c_lflag;
            public byte[] c_line = new byte[1];     // unused but required padding
            public byte[] c_cc = new byte[20];      // control chars
            public NativeLong c_ispeed;
            public NativeLong c_ospeed;

            @Override
            protected java.util.List<String> getFieldOrder() {
                return java.util.Arrays.asList("c_iflag", "c_oflag", "c_cflag", "c_lflag",
                                            "c_line", "c_cc", "c_ispeed", "c_ospeed");
            }
        }

        CLibrary INSTANCE = Native.load("c", CLibrary.class);

        int tcgetattr(int fd, Termios termios);
        int tcsetattr(int fd, int actions, Termios termios);
        int getchar();
    }

    private static volatile boolean isInputScanning = true;

    private static void showActions() {
        System.out.println("1. Action 1");
        System.out.println("2. Action 2");
        System.out.println("0. Exit");
    }

    private static void enableRawMode() {
        final int STDIN = 0;
        final int TCSANOW = 0;

        final int ICANON = 0x00000100;
        final int ECHO   = 0x00000008;

        CLibrary.Termios orig = new CLibrary.Termios();
        CLibrary.Termios raw = new CLibrary.Termios();

        // Save current terminal settings
        CLibrary.INSTANCE.tcgetattr(STDIN, orig);
        CLibrary.INSTANCE.tcgetattr(STDIN, raw);

        // Disable canonical mode (ICANON) and echo (ECHO)
        long newFlags = raw.c_lflag.longValue();
        newFlags &= ~(ICANON | ECHO); // ICANON = 0x0002, ECHO = 0x0008
        raw.c_lflag = new NativeLong(newFlags);

        // Apply raw mode
        CLibrary.INSTANCE.tcsetattr(STDIN, TCSANOW, raw);        
    }

    private static void disableRawMode() {
        final int STDIN = 0;
        final int TCSANOW = 0;
        CLibrary.Termios orig = new CLibrary.Termios();

        // Restore original settings
        CLibrary.INSTANCE.tcsetattr(STDIN, TCSANOW, orig);
    }

    public static void main(String[] args) {

        enableRawMode();

        BlockingQueue<Character> inputQueue = new LinkedBlockingQueue<>();
        Thread inputThread = new Thread(() -> {
            int ch;
            while (true) {
                ch = CLibrary.INSTANCE.getchar();         
                if (ch > -1)               
                {
                    try {
                       inputQueue.put((char)ch);
                    } catch (InterruptedException e) {
                        //ignore
                    }
                }
            }
        });
        inputThread.setDaemon(true);
        inputThread.start();

        showActions();

        int running = 0;
        long lastTimestamp = System.currentTimeMillis();
        StringBuilder commandBuffer = new StringBuilder();

        while (isInputScanning) {

            Character achar = inputQueue.poll();
            if (achar != null) {
                int ch = achar;
                if (ch == 10 || ch == 13) { // Enter (LF or CR)
                    if (commandBuffer.toString().equals("1")) {
                        Global.shared().action1();
                    }
                    else if (commandBuffer.toString().equals("2")) {
                        Global.shared().action2();
                    }

                    isInputScanning = false; // exit loop
                    System.out.println("\nExited.");
                    return;

                } 
                else if (ch == 127 || ch == 8) { // Backspace or Delete
                    if (commandBuffer.length() > 0) {
                        commandBuffer.deleteCharAt(commandBuffer.length() - 1);
                    }
                } 
                else if (ch >= 32 && ch <= 126) { // printable ASCII
                    commandBuffer.append((char) ch);
                }
                System.out.printf("\033[2K\rRun loop: %d | Type command: %s",running,commandBuffer.toString());
            }

            long nowTimestamp = System.currentTimeMillis();
            if (nowTimestamp - lastTimestamp > 1000) {
                System.out.printf("\033[2K\rRun loop: %d | Type command: %s",running,commandBuffer.toString());
                
                running++;
                lastTimestamp = nowTimestamp;
            }

        }

        disableRawMode();
    }
}
