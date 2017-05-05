//
//  VDConstants.swift
//  VoxboneDemo
//
//  Copyright © 2017 Voxbone. All rights reserved.
//

import Foundation
import UIKit

struct VDConstants {
    
    struct Segue {
        static let toHome = "toHomeSegue"
    }
    
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
    
    struct Color {
        static let violet: UIColor = UIColor(red: 113.0/255.0, green: 29.0/255.0, blue: 117.0/255.0, alpha: 1.0)
    }
    
    struct Voxbone {
        struct Credentials {
            static let username = "WebRTCUsername" //Your Voxbone WebRTC username
            static let password = "WebRTCPassword" //Your Voxbone WebRTC Password. Go to https://www.voxbone.com/portal/account-settings?tab=webRTC to setup
            static let apiKey = "YourAPIKey" //Your iOS API username/key
            static let apiSecret = "YourAPISecret" //Your iOS API secret, provided by Voxbone. Please contact workshop@voxbone.com for access
            static let appName = "YourAppName" //Your iOS App Name
        }
    }
}
