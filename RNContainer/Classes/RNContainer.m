#import "RNContainer.h"
#import "RNBridge.h"
#import <React/RCTRootView.h>

@implementation RNContainer

- (UIViewController *)viewControllerByRoute:(NSString *)routeName withParams:(NSDictionary *)params {
  UIViewController *viewController = [[UIViewController alloc] init];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[RNBridge sharedBridge].bridge
                                                   moduleName:routeName
                                            initialProperties:params];
  viewController.view = rootView;
  return viewController;
}

- (UIViewController *)viewControllerByRoute:(NSString *)routeName {
  return [self viewControllerByRoute:routeName withParams:nil];
}

@end
