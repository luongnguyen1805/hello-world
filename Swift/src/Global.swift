
class Global 
{
    static let shared = Global()

    private init() { }

    func run(onExit: @escaping ()->Void) 
    {
        print("Singleton implementation.")
        onExit()
    }
}
