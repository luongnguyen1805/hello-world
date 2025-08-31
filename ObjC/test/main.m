#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int result = 1 + 1;
        int expected = 2;

        NSLog(@"Performing test: 1 + 1 == 2");

        if (result == expected) {
            NSLog(@"Test Passed: 1 + 1 == %d", result);
            return 0; // Return 0 for success
        } else {
            NSLog(@"Test Failed: Expected %d but got %d", expected, result);
            return 1; // Return a non-zero value for failure
        }
    }
}