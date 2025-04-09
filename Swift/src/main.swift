import Foundation

class RunLoop 
{
    static func start() {
        CFRunLoopRun()
    }

    static func stop() {
        let rl = CFRunLoopGetCurrent()
        CFRunLoopStop(rl)
    }
    
}

enum MenuOption: String {
    case one = "1"
    case two = "2"
    case exit = "0"
    
    var description: String {
        switch self {
        case .one: return "Singleton"
        case .two: return "Async Await"
        case .exit: return "Exit"
        }
    }

    static let allOptions: [MenuOption] = [.one, .two, .exit]
}

class ConsoleInput {

    private var inputSource: DispatchSourceRead?
    private let inputQueue = DispatchQueue(label: "com.console.input")
    
    func startReading(completion: @escaping (String) -> Void) {
        // Get stdin file descriptor
        let stdin = FileHandle.standardInput
        
        // Create DispatchSource to monitor stdin
        inputSource = DispatchSource.makeReadSource(fileDescriptor: stdin.fileDescriptor, queue: inputQueue)
        
        // Handle incoming data
        inputSource?.setEventHandler {
            let data = stdin.availableData
            if let input = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), !input.isEmpty {
                DispatchQueue.main.async {
                    completion(input)
                }
            }
        }
        
        // Handle cancellation
        inputSource?.setCancelHandler {
            stdin.closeFile()
        }
        
        // Start the source
        inputSource?.resume()
    }
    
    func stopReading() {
        inputSource?.cancel()
    }
    
    func printMenu() {

        print("Please Select an option:")

        for option in MenuOption.allOptions {
            print("\(option.rawValue). \(option.description)")
        }

    }
}

func main() {

    let console = ConsoleInput()
    
    // Start non-blocking input with DispatchSource
    console.startReading { choice in

        switch choice {
        case MenuOption.one.rawValue:
            Global.shared.run {
                RunLoop.stop()
            }
        case MenuOption.two.rawValue:
            AsyncAwait().run {
                RunLoop.stop()
            }
        case MenuOption.exit.rawValue:
            print("Goodbye!")
                RunLoop.stop()
        default:
            print("Invalid option. Please try again.")
        }
        print("")
    }
    
    // Initial menu display
    console.printMenu()

    RunLoop.start()
}

main()