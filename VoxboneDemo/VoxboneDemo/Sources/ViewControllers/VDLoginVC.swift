//
//  VDLoginVC.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/4/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import UIKit
import AVFoundation

class VDLoginVC: UIViewController {
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonConnect: UIButton!
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonConnectState(false)
        
        buttonConnect.clipsToBounds = true
        buttonConnect.layer.cornerRadius = 5
        
        textFieldUsername.text = "test1@voxbonedemo.voxboneworkshop.voximplant.com"
        textFieldPassword.text = "123456"
        
        checkRecordPermission()
    }

    @IBAction func onClickConnect() {
        if textFieldUsername.text != nil, textFieldUsername.text!.characters.count <= 0,
            textFieldPassword.text != nil, textFieldPassword.text!.characters.count <= 0 {
            print("Error: Username & Password is required!")
            return
        }
        
        VDLoadingView.shared.display(view: view)
        VDVoxboneManager.shared.connect(
            onConnectionSuccessful: {
                self.login()
            }, onConnectionFailed: { (_ error: Error) in
                print("Error: \(error)")
                self.setButtonConnectState(false)
                VDLoadingView.shared.hide()
            }, onConnectionClosed: {
                self.setButtonConnectState(false)
                VDLoadingView.shared.hide()
            })
    }
    
    func login() {
        VDVoxboneManager.shared.login(textFieldUsername.text!, textFieldPassword.text!,
            onLoginSuccessful: { (_ displayName: String, _ authParams: [AnyHashable : Any]) in
                self.setButtonConnectState(true)
                VDLoadingView.shared.hide()
                self.performSegue(withIdentifier: VDConstants.Segue.toHome, sender: nil)
            }, onLoginFailed: { (_ errorCode: NSNumber) in
                print("Error: \(errorCode)")
                VDVoxboneManager.shared.close(onConnectionClosed: {
                    self.setButtonConnectState(false)
                    VDLoadingView.shared.hide()
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
    
    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission() {
            case AVAudioSessionRecordPermission.undetermined:
                requestRecordPermission()
                break
            case AVAudioSessionRecordPermission.denied:
                presentPopupAlertForRecordPermission()
                break
            case AVAudioSessionRecordPermission.granted:
                print("Microphone Record Permission Granted")
                break
            default:
                break
        }
    }
    
    func requestRecordPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted: Bool) in
            if granted {
                print("Microphone Record Permission Granted")
            } else {
                self.presentPopupAlertForRecordPermission()
            }
        })
    }
    
    func presentPopupAlertForRecordPermission() {
        let alert = UIAlertController(title:"Error", message:"Please go to Settings and allow Microphone access to have a correct use of Voxbone Demo App!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
}


