//
//  ViewController.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/4/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import UIKit
import VoxboneSDK

class ViewController: UIViewController {

    var wrapper: VBWrapper = VBWrapper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        VBWrapper.setLogLevel(.VOXBONE_ERROR_LOG_LEVEL)
        wrapper.setVoxboneDelegate(delegate: self)
    }
    
    @IBAction func onClickConnect() {
        wrapper.connect(false)
    }
}

extension ViewController: VoxboneDelegate {
    
    func onLoginSuccessful(withDisplayName displayName: String!, andAuthParams authParams: [AnyHashable : Any]!) {
        print("onLoginSuccessful: displayName - \(displayName)")
        wrapper.closeConnection()
    }
    
    func onLoginFailedWithErrorCode(_ errorCode: NSNumber!) {
        print("onLoginFailedWithErrorCode: errorCode - \(errorCode)")
    }
    
    func onConnectionSuccessful() {
        print("onConnectionSuccessful")
        wrapper.login(withUsername: "test1@voxbonedemo.voxboneworkshop.voximplant.com", andPassword: "123456")
    }
    
    func onConnectionClosed() {
        print("onConnectionClosed")
    }
    
    func onConnectionFailedWithError(_ reason: String!) {
        print("onConnectionFailedWithError: reason - \(reason)")
    }
}
