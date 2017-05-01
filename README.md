# VoxboneSDK

## Installation Steps:

To integrate VoxboneSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'VoxboneSDK'
end
```
Then, run the following command:
```
pod install
```

## Getting Started:

### Log Level
```
Voxbone.setLogLevel(.VOXBONE_INFO_LOG_LEVEL)
```

### Shared instance & delegate
```
var voxbone: Voxbone = Voxbone.shared
voxbone.setVoxboneDelegate(delegate: self)
```

### Connect action
```
voxbone.connect(false)
```

### Login action
```
voxbone.loginToVoxbone(withUsername: "your username", andAppName: "your app name", andPassword: "your password")
```

### Start Call action
```
if let callId = voxbone.createVoxboneCall("phone number") {
        voxbone.startCall(callId, withHeaders: nil)
}
```

### End Call action
```
if callId != nil {
        voxbone.disconnectCall(callId!, withHeaders: nil)
}
```
