//
//  VDHomeVC.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/20/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import UIKit
import VoxboneSDK

class VDHomeVC: UIViewController {

    @IBOutlet weak var buttonCall: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func onClickCall() {
        //let callTo = "16502106894"
        let callTo = "test2"//@voxbonedemo.voxboneworkshop.voximplant.com"
        VDVoxboneManager.shared.call(to: callTo, 
            onCallConnected: { (VDOnCallConnectedHandler) in
                
            }, onCallDisconnected: { (VDOnCallDisconnectedHandler) in
            
            }, onCallRinging: { (VDOnCallRingingHandler) in
            
            }, onCallFailed: { (VDOnCallFailedHandler) in
            
            }, onCallAudioStarted: { (VDOnCallAudioStartedHandler) in
            
            })
    }
}
