import java.util.Scanner;

public class Main {

    private static volatile boolean isInputScanning = true;

    private static void showActions() {
        System.out.println("1. Action 1");
        System.out.println("2. Action 2");
        System.out.println("0. Exit");
    }

    public static void main(String[] args) {

        // Start input thread
        Thread inputThread = new Thread(() -> {
            Scanner scanner = new Scanner(System.in);
            while (isInputScanning) {
                if (scanner.hasNextLine()) {
                    String line = scanner.nextLine();
                    if (line.equalsIgnoreCase("0")) {
                        isInputScanning = false;
                    }
                }
            }
            scanner.close();
        });
        inputThread.setDaemon(true);
        inputThread.start();

        showActions();
        int running = 0;
        while (isInputScanning) {
            try {
                running++;

                System.out.printf("\033[2K\rEvent loop: %d | Type command: ",running);
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                break;
            }
        }

        System.out.println("Exit.");
    }
}
