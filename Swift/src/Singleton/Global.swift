
class Global 
{
    static let shared = Global()

    private init() { }

    func run() 
    {
        print("Singleton implementation.")
    }
}
