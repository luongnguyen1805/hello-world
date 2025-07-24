namespace MyApp;

public class Program {

    public static void ShowActions() {
        Console.WriteLine("1. Action 1");
        Console.WriteLine("2. Action 2");
        Console.WriteLine("0. Exit");    
    }

    public static void Main() {

        int running = 1;
        string commandBuffer = "";

        ShowActions();
        
        long lastTimestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();

        while (running > 0)
        {
            if (Console.KeyAvailable)
            {
                ConsoleKeyInfo key = Console.ReadKey(true); // true = don't show key
                char ch = key.KeyChar;

                if (key.Key == ConsoleKey.Enter)
                {
                    if (commandBuffer == "0")
                    {
                        Console.WriteLine("\nExited.");
                        break;
                    }
                }
                else if (key.Key == ConsoleKey.Backspace || key.Key == ConsoleKey.Delete)
                {
                    if (commandBuffer.Length > 0)
                    {
                        commandBuffer = commandBuffer[..^1];
                    }
                }
                else if (ch >= 32 && ch <= 126)
                {
                    commandBuffer += ch;
                }

                Console.Write($"\x1B[2K\rRun loop: {running} | Type command: {commandBuffer}");
            }

            long nowTimestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            if (nowTimestamp - lastTimestamp > 1000)
            {
                Console.Write($"\x1B[2K\rRun loop: {running} | Type command: {commandBuffer}");                

                lastTimestamp = nowTimestamp;
                running++;
            }

        }

    }
}

public class Global
{
    public static readonly Global Shared = new Global();
    private Global()
    {
        Console.WriteLine("Bad init");
    }
}

