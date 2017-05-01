Pod::Spec.new do |spec|
  spec.name = "VoxboneSDK"
  spec.version = "1.0.0"
  spec.summary = "VoxboneSDK framework!"
  spec.homepage = "https://github.com/voxbone-workshop/ios-sdk"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Jerónimo Valli" => 'jeronimo.valli@gmail.com' }
  spec.social_media_url = "https://twitter.com/voxbone"

  spec.platform = :ios, "9.0"
  spec.ios.deployment_target = "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/voxbone-workshop/ios-sdk.git", tag: "#{spec.version}", submodules: true }
  #spec.source = { http: "https://github.com/voxbone-workshop/ios-sdk/archive/1.0.0.zip" }
  spec.source_files = "VoxboneSDK/**/*.{h,swift}"
  spec.xcconfig = { "ARCHS" => ["arm64", "armv7", "armv7s", "x86_64"], "VALID_ARCHS" => ["arm64", "armv7", "armv7s", "x86_64"] }

  #spec.dependency "VoxImplantSDK"
  spec.dependency "Alamofire"
  spec.dependency "SwiftyJSON"
  spec.dependency "Flurry-iOS-SDK/FlurrySDK"
end
