#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNConfig : NSObject
  
+ (void)configByURL:(NSURL *)url;
+ (NSURL *)bundleUrl;

@end

NS_ASSUME_NONNULL_END
