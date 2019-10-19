#import "RNConfig.h"

static NSURL *_bundleURL = nil;

@implementation RNConfig

+ (void)configByURL:(NSURL *)url {
  _bundleURL = [url copy];
}

+ (NSURL *)bundleUrl {
  return [_bundleURL copy];
}

@end
