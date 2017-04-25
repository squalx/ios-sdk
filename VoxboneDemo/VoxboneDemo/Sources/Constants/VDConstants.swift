//
//  VDConstants.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/20/17.
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
            static let username = "workshopdev" //WebRTC Username
            static let password = "SnJ7Tk7x*rpS" //WebRTC Password
            static let apiUser = "techrrific" //Voximplant Username
            static let apiKey = "SPH154#K5QIv" //Voximplant password
        }
    }
}
