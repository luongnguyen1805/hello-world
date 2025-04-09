// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class AsyncAwait {

    func doHeavyWork(onDone: @escaping ()->Void, onError: @escaping ()->Void) {

        DispatchQueue.global(qos: .default).async {
            Thread.sleep(forTimeInterval: 1)
            onDone()
        }

    }

    func doHeavyWorkAsync() async throws -> Bool {    

        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return true

    }

    func run(onExit: @escaping ()->Void) {

        print("Convert Concurrent-Callback Func to Async Func")

        doHeavyWork(onDone: {
            DispatchQueue.main.async {
                print("Heavy Work Done")
            }
        },onError: { 
            DispatchQueue.main.async {
                print("Heavy Work Error")
            }
        })

        Task {
            do {
                _ = try await doHeavyWorkAsync()
            }
            catch {
                DispatchQueue.main.async {
                    print("Heavy Work Async Error")
                    onExit()
                }
            }
            
            DispatchQueue.main.async {
                print("Heavy Work Async Done")
                onExit()
            }
        }

    }
}




