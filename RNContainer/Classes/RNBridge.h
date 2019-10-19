#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNBridge : NSObject
  
@property (nonatomic, strong, readonly) RCTBridge *bridge;  
+ (instancetype _Nonnull)sharedBridge;

@end

NS_ASSUME_NONNULL_END
