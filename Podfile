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
