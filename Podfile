# CocoaPods Source
# source 'https://github.com/CocoaPods/Specs.git'

# iOS Platform
platform :ios, '9.0'
use_frameworks!

workspace 'Voxbone'

target 'VoxboneSDK' do
    project 'VoxboneSDK/VoxboneSDK.xcodeproj'
    pod 'VoxImplantSDK'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'Flurry-iOS-SDK/FlurrySDK'
end

target 'VoxboneDemo' do
    project 'VoxboneDemo/VoxboneDemo.xcodeproj'
    pod 'VoxboneSDK'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
