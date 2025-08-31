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

    private var commandBuffer = ""
    private var running: UInt64 = 0
    private var keepRunning = true
    private var origTerm = termios()

    func startReading(completion: @escaping (String) -> Void) {
        let fd = FileHandle.standardInput.fileDescriptor

        // Save and enable raw mode
        tcgetattr(fd, &origTerm)
        var raw = origTerm
        raw.c_lflag &= ~(UInt(ICANON | ECHO))
        raw.c_cc.16 /* VMIN */ = 1
        raw.c_cc.17 /* VTIME */ = 0
        tcsetattr(fd, TCSANOW, &raw)

        // Thread to read keystrokes
        DispatchQueue.global(qos: .userInteractive).async {
            var buf = [UInt8](repeating: 0, count: 1)
            while self.keepRunning {
                let n = read(fd, &buf, 1)
                if n > 0 {
                    let ch = buf[0]
                    DispatchQueue.main.async {
                        self.handleChar(ch, completion: completion)
                    }
                }
            }
        }

        // Thread to tick every second
        DispatchQueue.global(qos: .background).async {
            while self.keepRunning {
                Thread.sleep(forTimeInterval: 1.0)
                DispatchQueue.main.async {
                    self.running += 1
                    self.redrawPrompt()
                }
            }
        }
    }

    private func handleChar(_ ch: UInt8, completion: @escaping (String) -> Void) {
        if ch == 10 || ch == 13 { // Enter
            let command = commandBuffer
            if (command == "0") {
                completion(command)
            }
        } else if ch == 127 || ch == 8 { // Backspace
            if !commandBuffer.isEmpty {
                commandBuffer.removeLast()
            }
        } else if ch >= 32 && ch <= 126 {
            commandBuffer.append(Character(UnicodeScalar(ch)))
        }

        redrawPrompt()
    }

    private func redrawPrompt() {
        if (!keepRunning)
        {
            return;
        }

        let out = "\u{1B}[2K\rRun loop \(running) | Type command: \(commandBuffer)"
        FileHandle.standardOutput.write(out.data(using: .utf8)!)
    }

    func stopReading() {
        keepRunning = false
        // restore terminal
        let fd = FileHandle.standardInput.fileDescriptor
        tcsetattr(fd, TCSANOW, &origTerm)
        print("\nExited.")
    }
    
    func printMenu() {
        for option in MenuOption.allOptions {
            print("\(option.rawValue). \(option.description)")
        }
    }
}

func main() {

    let console = ConsoleInput()

    // Initial menu display
    console.printMenu()

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
            console.stopReading();
            RunLoop.stop()
        default:
            print("Invalid option. Please try again.")
        }
    }
    
    RunLoop.start()
}

main()