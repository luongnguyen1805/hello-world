
public class Global
{
    public static readonly Global Shared = new();
    private Global()
    { 
    }

    public void Action1()
    {
        Console.Write("\n...Action1...");
    }

    public void Action2()
    {
        Console.Write("\n...Action2...");
    }

}

