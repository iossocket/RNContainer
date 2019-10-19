#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNContainer : NSObject

- (UIViewController *)viewControllerByRoute:(NSString *)routeName withParams:(NSDictionary * _Nullable)params;
- (UIViewController *)viewControllerByRoute:(NSString *)routeName;

@end

NS_ASSUME_NONNULL_END
