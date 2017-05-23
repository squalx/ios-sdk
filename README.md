# VoxboneSDK

## What you will need
- iOS app using Swift 3
- Xcode 8.0 or later
- iOS 9 or later
- CocoaPods
- Voxbone Account (for WebRTC API credentials, refer to **[documentation here](https://developers.voxbone.com/how-to/setup-webrtc/)** to set up)
- iOS SDK credentials (**[contact us](mailto:workshop@voxbone.com?subject=iOS%20SDK%20access%20needed)** for access)

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

### Import
```
import VoxboneSDK
```

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
voxbone.loginToVoxbone(withUsername: "your username", andPassword: "your password", andUser: "your user", andAppName: "your app name", andSecret: "your secret")
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
