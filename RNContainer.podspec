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
