
Console.WriteLine("Hello World");

public class Global 
{
    public static readonly Global Shared = new Global();
    private Global() { 
        Console.WriteLine("Bad init");
    }
}
