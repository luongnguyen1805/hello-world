
namespace MyApp;

public class Program {

    public static void ShowActions() {
        Console.WriteLine("1. Action 1");
        Console.WriteLine("2. Action 2");
        Console.WriteLine("0. Exit");    
    }

    public static void Main() {

        int running = 0;

        ShowActions();

        while (true)
        {
            running++;

            if (Console.KeyAvailable)
            {
                ConsoleKeyInfo key = Console.ReadKey(true); // true = don't show key

                if (key.Key == ConsoleKey.D0)
                {
                    Console.WriteLine("\nExit.");
                    break;
                }
            }

            Console.Write($"\x1B[2K\rEvent loop: {running} | Type command: ");
            Thread.Sleep(1000);
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

