
#import "Global.h"

@implementation Global

+ (instancetype) shared {
    static Global *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    return sharedInstance;
}

- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[GlobalManager shared]"
                                 userInfo:nil];
    return nil;
}

- (instancetype) initPrivate {
    self = [super init];
    if (self) {
        // Initialize global state here
    }
    return self;
}

- (void) action1 {
    printf("\n...Action1...");
}

- (void) action2 {
    printf("\n...Action2...");
}

@end
