//
//  VDHomeVC.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/20/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import Foundation
import UIKit
import VoxboneSDK

class VDHomeVC: UIViewController {
    
    static let textCall = "Call"
    static let textHangup = "End"

    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var buttonStarSign: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonPoundSign: UIButton!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var buttonMute: UIButton!
    @IBOutlet weak var buttonSpeaker: UIButton!
    
    var isOnCall: Bool = false
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        buttonCall.clipsToBounds = true
        buttonCall.layer.cornerRadius = 5
        
        buttonClear.clipsToBounds = true
        buttonClear.layer.cornerRadius = buttonClear.bounds.size.width/2
        buttonClear.layer.borderColor = VDConstants.Color.violet.cgColor
        buttonClear.layer.borderWidth = 1.0
        
        button1.clipsToBounds = true
        button1.layer.cornerRadius = button1.bounds.size.width/2
        
        button2.clipsToBounds = true
        button2.layer.cornerRadius = button2.bounds.size.width/2
        
        button3.clipsToBounds = true
        button3.layer.cornerRadius = button3.bounds.size.width/2
        
        button4.clipsToBounds = true
        button4.layer.cornerRadius = button4.bounds.size.width/2
        
        button5.clipsToBounds = true
        button5.layer.cornerRadius = button5.bounds.size.width/2
        
        button6.clipsToBounds = true
        button6.layer.cornerRadius = button6.bounds.size.width/2
        
        button7.clipsToBounds = true
        button7.layer.cornerRadius = button7.bounds.size.width/2
        
        button8.clipsToBounds = true
        button8.layer.cornerRadius = button8.bounds.size.width/2
        
        button9.clipsToBounds = true
        button9.layer.cornerRadius = button9.bounds.size.width/2
        
        buttonStarSign.clipsToBounds = true
        buttonStarSign.layer.cornerRadius = buttonStarSign.bounds.size.width/2
        
        button0.clipsToBounds = true
        button0.layer.cornerRadius = button0.bounds.size.width/2
        
        buttonPoundSign.clipsToBounds = true
        buttonPoundSign.layer.cornerRadius = buttonPoundSign.bounds.size.width/2
        
        buttonMute.clipsToBounds = true
        buttonMute.layer.cornerRadius = 5
        buttonMute.layer.borderColor = VDConstants.Color.violet.cgColor
        buttonMute.layer.borderWidth = 1.0
        
        buttonSpeaker.clipsToBounds = true
        buttonSpeaker.layer.cornerRadius = 5
        buttonSpeaker.layer.borderColor = VDConstants.Color.violet.cgColor
        buttonSpeaker.layer.borderWidth = 1.0
        
        buttonSpeaker.isHidden = true
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone, !VDConstants.Platform.isSimulator {
            buttonSpeaker.isHidden = false
        }
        
        title = VDVoxboneManager.shared.userName
        
        textFieldInput.text = "5492216093000"
        //textFieldInput.text = "test2"//@voxbonedemo.voxboneworkshop.voximplant.com"
        
        updateButtonsForCallState()
        
        VDVoxboneManager.shared.connectionClosed = {
            VDLoadingView.shared.hide()
            self.isOnCall = false
            self.updateButtonsForCallState()
            _ = self.navigationController?.popViewController(animated: true)
            let alert = UIAlertController(title:"Error", message:"The connection was closed!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            self.navigationController?.viewControllers.first?.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickButtonPad(sender: UIButton) {
        
        var newText: String = ""
        if sender.tag == 10 {
            newText = "*"
        } else if sender.tag == 11 {
            newText = "#"
        } else {
            newText = "\(sender.tag)"
        }
        if let text = textFieldInput.text {
            textFieldInput.text = "\(text)\(newText)"
        } else {
            textFieldInput.text = "\(newText)"
        }
    }
    
    @IBAction func onClickButtonClear() {
        if let callTo = textFieldInput.text {
            textFieldInput.text = String(callTo.characters.dropLast())
        }
    }
    
    @IBAction func onClickLogOut() {
        VDLoadingView.shared.display(view: view)
        VDVoxboneManager.shared.close(onConnectionClosed: {
            VDLoadingView.shared.hide()
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func onClickCall() {
        if buttonCall.title(for: .normal) == VDHomeVC.textHangup {
            VDVoxboneManager.shared.hangup(onCallDisconnected: { (callId: String!, headers: [AnyHashable : Any]!) in
                self.isOnCall = false
                self.updateButtonsForCallState()
            })
            return
        }
        
        if let callTo = textFieldInput.text {
            isOnCall = true
            updateButtonsForCallState()
            VDVoxboneManager.shared.call(to: callTo,
                onCallConnected: { (VDOnCallConnectedHandler) in
                    
                }, onCallDisconnected: { (VDOnCallDisconnectedHandler) in
                    self.isOnCall = false
                    self.updateButtonsForCallState()
                }, onCallRinging: { (VDOnCallRingingHandler) in
                    
                }, onCallFailed: { (callId: String, code: Int32, reason: String, headers: [AnyHashable : Any]) in
                    self.isOnCall = false
                    self.updateButtonsForCallState()
                    self.presentPopupAlertForCallFailed(reason)
                }, onCallAudioStarted: { (VDOnCallAudioStartedHandler) in
                
            })
        }
    }
    
    @IBAction func onClickButtonMute() {
        buttonMute.isSelected = !buttonMute.isSelected
        VDVoxboneManager.shared.setMute(buttonMute.isSelected)
    }
    
    @IBAction func onClickButtonSpeaker() {
        buttonSpeaker.isSelected = !buttonSpeaker.isSelected
        _ = VDVoxboneManager.shared.setUseLoudspeaker(buttonSpeaker.isSelected)
    }
    
    func updateButtonsForCallState() {
        if isOnCall {
            buttonCall.setTitle(VDHomeVC.textHangup, for: .normal)
            buttonMute.isEnabled = true
            buttonSpeaker.isEnabled = true
        } else {
            buttonCall.setTitle(VDHomeVC.textCall, for: .normal)
            buttonMute.isEnabled = false
            buttonSpeaker.isEnabled = false
            buttonMute.isSelected = false
            buttonSpeaker.isSelected = false
        }
    }
    
    func presentPopupAlertForCallFailed(_ message: String) {
        let alert = UIAlertController(title:"Error", message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
        present(alert, animated: true, completion: nil)
    }
}
