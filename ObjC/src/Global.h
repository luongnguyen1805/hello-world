
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Global : NSObject

+ (instancetype) shared;

- (void) action1;
- (void) action2;

@end

NS_ASSUME_NONNULL_END