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
        
        buttonCall.clipsToBounds = true
        buttonCall.layer.cornerRadius = 5
    }
    
    @IBAction func onClickCall() {
        let callTo = "5492216093000"//"5492215585444"//"16502106894"
        //let callTo = "test2"//@voxbonedemo.voxboneworkshop.voximplant.com"
        VDVoxboneManager.shared.call(to: callTo, 
            onCallConnected: { (VDOnCallConnectedHandler) in
                self.setButtonCallState(true)
            }, onCallDisconnected: { (VDOnCallDisconnectedHandler) in
                self.setButtonCallState(false)
            }, onCallRinging: { (VDOnCallRingingHandler) in
            
            }, onCallFailed: { (VDOnCallFailedHandler) in
                self.setButtonCallState(false)
            }, onCallAudioStarted: { (VDOnCallAudioStartedHandler) in
            
            })
    }
    
    func setButtonCallState(_ isOnCall: Bool) {
        if isOnCall {
            buttonCall.setTitle("Hangup", for: .normal)
        } else {
            buttonCall.setTitle("Call", for: .normal)
        }
    }
}
