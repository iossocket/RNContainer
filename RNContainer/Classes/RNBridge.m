#import "RNBridge.h"
#import "RNBridgeDelegate.h"

@implementation RNBridge {
  RNBridgeDelegate *_delegate;
}

static RNBridge *_bridge = nil;
+ (instancetype)sharedBridge
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _bridge = [[RNBridge alloc] init];
  });
  return _bridge;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _delegate = [[RNBridgeDelegate alloc] init];
    _bridge = [[RCTBridge alloc] initWithDelegate:_delegate launchOptions:nil];
  }
  return self;
}

@end
