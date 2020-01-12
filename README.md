# RNContainer

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RNContainer is available through [My Private Pods](https://github.com/iossocket/ReactNativeLib.git). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RNContainer'
```

## How to build Framework

Install cocoapods-packager: `gem install cocoapods-packager`

```
pod package RNContainer.podspec --force --embedded --no-mangle --spec-sources=https://github.com/iossocket/ReactNativeLib.git,https://github.com/CocoaPods/Specs.git
```

## Author

iossocket, avx302@gmail.com

## License

RNContainer is available under the MIT license. See the LICENSE file for more info.
