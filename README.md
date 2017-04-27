# VoxboneSDK

## Dependencies:

* VoxImplantSDK
* Alamofire
* SwiftyJSON
* Flurry-iOS-SDK/FlurrySDK

## Manual Installation Steps:

1. Download the zip file VoxboneSDK.zip from https://github.com/voxbone-workshop/ios-sdk/releases/download/1.0.0/VoxboneSDK_1.0.0.zip
2. Unzip the file VoxboneSDK.zip and move the VoxboneSDK.framework to your project folder
3. On Xcode select your project target and go to Build Phases tab
4. Press on plus button from Link Binary With Libraries, search for VoxboneSDK.framework and include it

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
