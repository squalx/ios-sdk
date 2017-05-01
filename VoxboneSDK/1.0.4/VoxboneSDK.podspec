Pod::Spec.new do |spec|
  spec.name = 'VoxboneSDK'
  spec.version = '1.0.4'
  spec.summary = 'VoxboneSDK framework!'
  spec.homepage = 'https://github.com/voxbone-workshop/ios-sdk'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors = { 'Jerónimo Valli' => 'jeronimo.valli@gmail.com' }

  spec.ios.deployment_target = '9.0'
  spec.requires_arc = true
  spec.source = { :git => 'https://github.com/voxbone-workshop/ios-sdk.git', :tag => spec.version.to_s }
  spec.source_files = 'VoxboneSDK/**/*.{h,swift}'

  spec.frameworks = 'Foundation'
  spec.dependency 'VoxImplantSDK'
  spec.dependency 'Alamofire'
  spec.dependency 'SwiftyJSON'
  spec.dependency 'Flurry-iOS-SDK/FlurrySDK'
end
