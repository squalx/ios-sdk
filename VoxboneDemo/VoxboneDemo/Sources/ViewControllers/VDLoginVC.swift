//
//  VDLoginVC.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/4/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

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
        
        buttonConnect.clipsToBounds = true
        buttonConnect.layer.cornerRadius = 5
        
        textFieldUsername.text = "workshopdev"
        textFieldPassword.text = "SnJ7Tk7x*rpS"
        
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
                VDLoadingView.shared.hide()
                self.presentPopupAlertForConnectionFailed(error)
            }, onConnectionClosed: {
                VDLoadingView.shared.hide()
                self.presentPopupAlertForConnectionClosed()
            })
    }
    
    func login() {
        VDVoxboneManager.shared.login(textFieldUsername.text!, textFieldPassword.text!,
            onLoginSuccessful: { (_ displayName: String, _ authParams: [AnyHashable : Any]) in
                VDLoadingView.shared.hide()
                self.performSegue(withIdentifier: VDConstants.Segue.toHome, sender: nil)
            }, onLoginFailed: { (_ errorCode: NSNumber) in
                print("Error: \(errorCode)")
                VDVoxboneManager.shared.close(onConnectionClosed: {
                    VDLoadingView.shared.hide()
                    self.presentPopupAlertForConnectionFailed(nil)
                })
            })
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
        presentPopupAlert("Please go to Settings and allow Microphone access to have a correct use of Voxbone Demo App!")
    }
    
    func presentPopupAlertForConnectionFailed(_ error: Error?) {
        if error != nil {
            presentPopupAlert(error!.localizedDescription)
        } else {
            presentPopupAlert("")
        }
    }
    
    func presentPopupAlertForConnectionClosed() {
        presentPopupAlert("The connection was closed!")
    }
    
    func presentPopupAlert(_ message: String) {
        let alert = UIAlertController(title:"Error", message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
        present(alert, animated: true, completion: nil)
    }
}


