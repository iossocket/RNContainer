### 题外话
React Native已经🔥了很久了，从某种程度上说它提高了开发效率，尤其对应对测试覆盖率有较高要求时，写测试耗费的时间甚至会超过写实现的时间，根据笔者在多个真实项目上的实践，如果说写iOS和Android两个App的时间是2，那么采用React Native的时间为1.5 ~ 1.8，这0.3的差距在于对UI是否有特殊要求，比如复杂的手势、动画要求，以及在需要Native Module时，没有合适的三方库需要自己实现。

那在技术栈决策时，是否应该选择RN，或是如何使用RN呢？（以下观点仅代表个人经验）。
1. 对于一个新项目，取决于项目的愿景，如果是一个功能相对简单的那么RN或是Flutter决定是最佳选择；但若项目是一个庞然大物，并且会有多团队分布式开发，那么更建议使用Hybrid的方式，将RN或Flutter作为Framework的方式引入。这样必然会引入工程复杂度，既然已经是个巨型App，那么这个复杂度和整体效率上比较，也是可以接受的。
2. 对于一个已有项目，推到用RN重写，是不建议的。尤其在对RN没有深刻认识时。此时可按照[官方文档](https://facebook.github.io/react-native/docs/integration-with-existing-apps#configuring-maven)里的集成方式，简单集成尝试后，再做判断。
> Tip： 此处并没有考虑到团队成员的现有技术栈，但作为一个Developer，保持持续学习，快速掌握新技能，应该是一个必要条件吧。

### 开始

刚刚提到了[官方文档](https://facebook.github.io/react-native/docs/integration-with-existing-apps#configuring-maven)，这种方式集成比较方便，后期升级也相对容易，但入侵性较大，会改变原有项目结构。Native代码和RN代码会揉在一起，降低了可维护性。

那么如何将RN作为一个Framework的方式引入呢？就像引入一个普通的三方库：`pod 'MyRNModule', '0.0.1'`。在原有代码中只需要import这个module，拿到它暴露出来的一个UIViewController，然后正常使用咯。

我们先来看看通过命令行构建一个RN项目后，`ios`目录下的Podfile是什么样的：
```ruby
platform :ios, '9.0'
require_relative '../node_modules/@react-native-community/cli-platform-ios/native_modules'

target 'Hybrid' do
  # Pods for Hybrid
  pod 'FBLazyVector', :path => "../node_modules/react-native/Libraries/FBLazyVector"
  pod 'FBReactNativeSpec', :path => "../node_modules/react-native/Libraries/FBReactNativeSpec"
  pod 'RCTRequired', :path => "../node_modules/react-native/Libraries/RCTRequired"
  pod 'RCTTypeSafety', :path => "../node_modules/react-native/Libraries/TypeSafety"
  pod 'React', :path => '../node_modules/react-native/'
  pod 'React-Core', :path => '../node_modules/react-native/'
  pod 'React-CoreModules', :path => '../node_modules/react-native/React/CoreModules'
  pod 'React-Core/DevSupport', :path => '../node_modules/react-native/'
  pod 'React-RCTActionSheet', :path => '../node_modules/react-native/Libraries/ActionSheetIOS'
  pod 'React-RCTAnimation', :path => '../node_modules/react-native/Libraries/NativeAnimation'
  pod 'React-RCTBlob', :path => '../node_modules/react-native/Libraries/Blob'
  pod 'React-RCTImage', :path => '../node_modules/react-native/Libraries/Image'
  pod 'React-RCTLinking', :path => '../node_modules/react-native/Libraries/LinkingIOS'
  pod 'React-RCTNetwork', :path => '../node_modules/react-native/Libraries/Network'
  pod 'React-RCTSettings', :path => '../node_modules/react-native/Libraries/Settings'
  pod 'React-RCTText', :path => '../node_modules/react-native/Libraries/Text'
  pod 'React-RCTVibration', :path => '../node_modules/react-native/Libraries/Vibration'
  pod 'React-Core/RCTWebSocket', :path => '../node_modules/react-native/'

  pod 'React-cxxreact', :path => '../node_modules/react-native/ReactCommon/cxxreact'
  pod 'React-jsi', :path => '../node_modules/react-native/ReactCommon/jsi'
  pod 'React-jsiexecutor', :path => '../node_modules/react-native/ReactCommon/jsiexecutor'
  pod 'React-jsinspector', :path => '../node_modules/react-native/ReactCommon/jsinspector'
  pod 'ReactCommon/jscallinvoker', :path => "../node_modules/react-native/ReactCommon"
  pod 'ReactCommon/turbomodule/core', :path => "../node_modules/react-native/ReactCommon"
  pod 'Yoga', :path => '../node_modules/react-native/ReactCommon/yoga'

  pod 'DoubleConversion', :podspec => '../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
  pod 'glog', :podspec => '../node_modules/react-native/third-party-podspecs/glog.podspec'
  pod 'Folly', :podspec => '../node_modules/react-native/third-party-podspecs/Folly.podspec'

  target 'HybridTests' do
    inherit! :search_paths
    # Pods for testing
  end

  use_native_modules!
end
```
它引入了一系列的library，这些lib都是通过npm拿到本地的，而我们希望的是在`Podfile`中只依赖一个`MyRNModule`，那就需要一个私有的pods，并且在`MyRNModule.podspec`中依赖RN的这些lib。
![rn.png](https://upload-images.jianshu.io/upload_images/19765376-c665c564685f290e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

依赖问题就可以解决了，接下来要在`MyRNModule`写一个ViewController，来显示视图，我们来看一下`AppDelegate.m`中都做了什么：
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"Hybrid"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}
```
可以看到，这里也只是一些简单的操作，创建了一个`rootViewController`，然后把`RCTRootView`赋值给它的`view`。OK，那么我们开工~

1. Private Cocoapods
私有pod的步骤网上有很多，比如[这个](https://www.jianshu.com/p/0c640821b36f)。我在这里就不赘述了。这里附上我的私有[pod](https://github.com/iossocket/ReactNativeLib.git)。
下面就开始体力活了，把Podfile中的这些依赖的podspec文件修改后放在自己的私有cocoapods里，为什么要这样做？不能直接是有Facebook官方的么？这里涉及到cocoapods的工作原理，请自行Google。同时需要改原有的podspec的版本号，我们随意哪一个依赖看一看，它来自FBLazyVector.spec。
```ruby
require "json"

package = JSON.parse(File.read(File.join(__dir__, "..", "..", "package.json")))
version = package['version']

source = { :git => 'https://github.com/facebook/react-native.git' }
if version == '1000.0.0'
  # This is an unpublished version, use the latest commit hash of the react-native repo, which we’re presumably in.
  source[:commit] = `git rev-parse HEAD`.strip
else
  source[:tag] = "v#{version}"
end

Pod::Spec.new do |s|
  s.name                   = "FBLazyVector"
  s.version                = version
  s.summary                = "-"  # TODO
  s.homepage               = "http://facebook.github.io/react-native/"
  s.license                = package["license"]
  s.author                 = "Facebook, Inc. and its affiliates"
  s.platforms              = { :ios => "9.0", :tvos => "9.2" }
  s.source                 = source
  s.source_files           = "**/*.{c,h,m,mm,cpp}"
  s.header_dir             = "FBLazyVector"
end
```
我们主要修改两处：1. 版本号；2. source_files。一番折腾之后，现在的私有cocoapods已经创建完成，为了确认它工作正常，我们将Podfile中对于本地的依赖改为私有远端依赖:
```ruby
source 'https://github.com/iossocket/ReactNativeLib.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'

target 'Hybrid' do
  # Pods for Hybrid
  pod 'FBLazyVector'
  pod 'FBReactNativeSpec'
  pod 'RCTRequired'
  pod 'RCTTypeSafety'
  pod 'React'
  pod 'React-Core'
  pod 'React-CoreModules'
  pod 'React-Core/DevSupport'
  pod 'React-RCTActionSheet'
  pod 'React-RCTAnimation'
  pod 'React-RCTBlob'
  pod 'React-RCTImage'
  pod 'React-RCTLinking'
  pod 'React-RCTNetwork'
  pod 'React-RCTSettings'
  pod 'React-RCTText'
  pod 'React-RCTVibration'
  pod 'React-Core/RCTWebSocket'

  pod 'React-cxxreact'
  pod 'React-jsi'
  pod 'React-jsiexecutor'
  pod 'React-jsinspector'
  pod 'ReactCommon/jscallinvoker'
  pod 'ReactCommon/turbomodule/core'
  pod 'Yoga'

  pod 'DoubleConversion'
  pod 'glog'
  pod 'Folly'

  target 'HybridTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
```
在这里，我们指定了私有源为https://github.com/iossocket/ReactNativeLib.git，重新执行`pod install`，一切正常，下一步，我们开始构建自己module啦。

2. 创建一个React View的容器
我们来创建一个Cocoapods的模板工程`pod lib create RNContrainer`，[RNContrainer](https://github.com/iossocket/RNContainer)，其中核心代码如下：
```
- (UIViewController *)viewControllerByRoute:(NSString *)routeName withParams:(NSDictionary *)params {
  UIViewController *viewController = [[UIViewController alloc] init];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[RNBridge sharedBridge].bridge
                                                   moduleName:routeName
                                            initialProperties:params];
  viewController.view = rootView;
  return viewController;
}
```
创建一个以RCTRootView为root view的UIViewController。其他代码请参考[RNContrainer](https://github.com/iossocket/RNContainer)，生成之后请别忘了要添加到自己的私有Cocoapods中哟。
```
Pod::Spec.new do |s|
  s.name             = 'RNContainer'
  s.version          = '0.1.0'
  s.summary          = 'A short description of RNContainer.'
  s.description      = <<-DESC
                       DESC
  s.homepage         = 'https://github.com/iossocket/RNContainer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iossocket' => 'avx302@gmail.com' }
  s.source           = { :git => 'https://github.com/iossocket/RNContainer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'RNContainer/Classes/**/*'
  
  s.dependency 'FBLazyVector'
  s.dependency 'FBReactNativeSpec'
  s.dependency 'RCTRequired'
  s.dependency 'RCTTypeSafety'
  s.dependency 'React'
  s.dependency 'React-Core'
  s.dependency 'React-CoreModules'
  s.dependency 'React-Core/DevSupport'
  s.dependency 'React-RCTActionSheet'
  s.dependency 'React-RCTAnimation'
  s.dependency 'React-RCTBlob'
  s.dependency 'React-RCTImage'
  s.dependency 'React-RCTLinking'
  s.dependency 'React-RCTNetwork'
  s.dependency 'React-RCTSettings'
  s.dependency 'React-RCTText'
  s.dependency 'React-RCTVibration'
  s.dependency 'React-Core/RCTWebSocket'

  s.dependency 'React-cxxreact'
  s.dependency 'React-jsi'
  s.dependency 'React-jsiexecutor'
  s.dependency 'React-jsinspector'
  s.dependency 'ReactCommon/jscallinvoker'
  s.dependency 'ReactCommon/turbomodule/core'
  s.dependency 'Yoga'

  s.dependency 'DoubleConversion'
  s.dependency 'glog'
  s.dependency 'Folly'
end
```
3. 使用RNContainer
使用方法也就明了了，在Podfile中
```
source 'https://github.com/iossocket/ReactNativeLib.git'
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
target 'Hybrid' do
  pod 'RNContainer'
end
```
使用时
```
#import "RNContainer.h"
...
[[RNContainer alloc] viewControllerByRoute:@"Hybrid"];
...
```
其中参数为RN中注册的app name。

### 以Library的方式使用RN的建议打开方式
1. 负责RN模块开发的团队，按照官方建议的方式，创建RN项目，正常开发。
2. 在pipeline上，编写脚本，生成RN的jsbundle以及相应的多媒体资源，并将其提交如RNContainer中并打tag，更新podspec文件，添加resource字段，将新版本push到私有Cocoapods中。
3. 负责主应用的团队，更新Podfile中RNContainer的版本号，消费其提供的ViewController，也可以使用组件化方案进行集成如Target-Action。

> 弊端：RN的升级需要更加谨慎，当RN团队需要使用包含Native代码的三方库时，需要将这个依赖添加到RNContainer中

如果您对于构建方式有其他方案，我们可以一起探讨。

## How to build Framework

Install cocoapods-packager: `gem install cocoapods-packager`

```
pod package RNContainer.podspec --force --embedded --no-mangle --spec-sources=https://github.com/iossocket/ReactNativeLib.git,https://github.com/CocoaPods/Specs.git
```
