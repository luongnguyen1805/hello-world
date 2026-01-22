
class Global 
{
    static let shared = Global()

    private init() { }

    func action1(onExit: @escaping ()->Void) 
    {
        print("\n...Action1...")
        onExit()
    }

    func action2(onExit: @escaping ()->Void) 
    {
        print("\n...Action2...")
        onExit()
    }

}
