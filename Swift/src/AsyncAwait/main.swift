// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

func doHeavyWork(onDone: @escaping ()->Void, onError: @escaping ()->Void) {

    DispatchQueue.global(qos: .default).async {
        Thread.sleep(forTimeInterval: 2)

        DispatchQueue.main.async {
            onDone()
        }
    }
}

func doHeavyWorkAsync() async throws -> Bool {
    
    try await Task.sleep(nanoseconds: 2000000)

    return true
}

DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
    print("5 seconds later");

    CFRunLoopStop(CFRunLoopGetMain())
}

print("Convert Concurrent-Callback Func to Async Func")

// doHeavyWork(onDone: {
//     print("Heavy Work Done")
// },onError: { 
//     print("Heavy Work Error")
// })

Task {
    do {
        _ = try await doHeavyWorkAsync()
    }
    catch {
        DispatchQueue.main.async {
            print("Heavy Work Async Error")
        }
    }
    DispatchQueue.main.async {
        print("Heavy Work Async Done")
    }
}

CFRunLoopRun()

print("Exit")

/*
doHeavyWork(onDone: {
    ...
}, onError: {
    ...
})

Task {
    try 
    {
        await doHeavyWork
        synchronizer.dispatch({
            //when onDone
        })
    }
    catch {
        synchronizer.dispatch({
            //when onError
        })
    }
}
*/