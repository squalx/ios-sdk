//
//  VDLoginVC.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/4/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import UIKit

class VDLoginVC: UIViewController {
    
    @IBOutlet weak var buttonConnect: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonConnectState(false)
    }

    @IBAction func onClickConnect() {
        VDVoxboneManager.shared.connect(
            onConnectionSuccessful: { (VDOnConnectionSuccessfulHandler) in
                self.login()
            }, onConnectionFailed: { (VDOnConnectionFailedHandler) in
                self.setButtonConnectState(false)
            }, onConnectionClosed: { (VDOnConnectionClosedHandler) in
                self.setButtonConnectState(false)
            })
    }
    
    func login() {
        VDVoxboneManager.shared.login("test1@voxbonedemo.voxboneworkshop.voximplant.com", "123456",
            onLoginSuccessful: { (VDOnLoginSuccessfulHandler) in
                self.setButtonConnectState(true)
                self.performSegue(withIdentifier: Constants.Segue.toHome, sender: nil)
            }, onLoginFailed: { (VDOnLoginFailedHandler) in
                self.setButtonConnectState(false)
            })
    }
    
    func setButtonConnectState(_ isConnected: Bool) {
        if isConnected {
            buttonConnect.setTitle("Connected", for: .normal)
        } else {
            buttonConnect.setTitle("Connect", for: .normal)
        }
        buttonConnect.isEnabled = !isConnected
    }
}


