#import "RNBridgeDelegate.h"
#import "RNConfig.h"
#import <React/RCTBundleURLProvider.h>

@implementation RNBridgeDelegate
  
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
  NSURL *url = [RNConfig bundleUrl];
  if (url != nil) {
    return url;
  }
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
