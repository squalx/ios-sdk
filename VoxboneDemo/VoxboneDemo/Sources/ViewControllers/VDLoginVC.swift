//
//  VDLoginVC.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/4/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import UIKit

class VDLoginVC: UIViewController {
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonConnect: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonConnectState(false)
        
        buttonConnect.clipsToBounds = true
        buttonConnect.layer.cornerRadius = 5
        
        textFieldUsername.text = "test1@voxbonedemo.voxboneworkshop.voximplant.com"
        textFieldPassword.text = "123456"
    }

    @IBAction func onClickConnect() {
        if textFieldUsername.text != nil, textFieldUsername.text!.characters.count <= 0,
            textFieldPassword.text != nil, textFieldPassword.text!.characters.count <= 0 {
            print("Error: Username & Password is required!")
            return
        }
        
        VDVoxboneManager.shared.connect(
            onConnectionSuccessful: {
                self.login()
            }, onConnectionFailed: { (_ error: Error) in
                print("Error: \(error)")
                self.setButtonConnectState(false)
            }, onConnectionClosed: {
                self.setButtonConnectState(false)
            })
    }
    
    func login() {
        VDVoxboneManager.shared.login(textFieldUsername.text!, textFieldPassword.text!,
            onLoginSuccessful: { (_ displayName: String, _ authParams: [AnyHashable : Any]) in
                self.setButtonConnectState(true)
                self.performSegue(withIdentifier: Constants.Segue.toHome, sender: nil)
            }, onLoginFailed: { (_ errorCode: NSNumber) in
                print("Error: \(errorCode)")
                VDVoxboneManager.shared.close(onConnectionClosed: {
                    self.setButtonConnectState(false)
                })
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


