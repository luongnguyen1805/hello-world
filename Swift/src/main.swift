// The Swift Programming Language
// https://docs.swift.org/swift-book

class Global 
{
    static let shared = Global()

    private init() { }
}

print("Hello World")