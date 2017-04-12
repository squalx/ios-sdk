//
//  VDCallEndedVC.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 4/11/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import UIKit

class VDCallEndedVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var buttonStar1: VDStarButton!
    @IBOutlet weak var buttonStar2: VDStarButton!
    @IBOutlet weak var buttonStar3: VDStarButton!
    @IBOutlet weak var buttonStar4: VDStarButton!
    @IBOutlet weak var buttonStar5: VDStarButton!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var buttonSend: UIButton!
    
    var rating :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 10
        
        buttonSend.clipsToBounds = true
        buttonSend.layer.cornerRadius = 5
        
        textViewMessage.clipsToBounds = true
        textViewMessage.layer.cornerRadius = 5
        textViewMessage.layer.borderColor = VDConstants.Color.violet.cgColor
        textViewMessage.layer.borderWidth = 1
    }
    
    @IBAction func onClickButtonStar1(_ sender: VDStarButton) {
        var newValue = !sender.shouldFillColor
        if newValue == false && buttonStar2.shouldFillColor {
            newValue = true
        }
        sender.shouldFillStar(newValue)
        buttonStar2.shouldFillStar(false)
        buttonStar3.shouldFillStar(false)
        buttonStar4.shouldFillStar(false)
        buttonStar5.shouldFillStar(false)
        rating = 1
    }
    
    @IBAction func onClickButtonStar2(_ sender: VDStarButton) {
        var newValue = !sender.shouldFillColor
        if newValue == false && buttonStar3.shouldFillColor {
            newValue = true
        }
        sender.shouldFillStar(newValue)
        buttonStar1.shouldFillStar(newValue)
        buttonStar3.shouldFillStar(false)
        buttonStar4.shouldFillStar(false)
        buttonStar5.shouldFillStar(false)
        rating = 2
    }
    
    @IBAction func onClickButtonStar3(_ sender: VDStarButton) {
        var newValue = !sender.shouldFillColor
        if newValue == false && buttonStar4.shouldFillColor {
            newValue = true
        }
        sender.shouldFillStar(newValue)
        buttonStar1.shouldFillStar(newValue)
        buttonStar2.shouldFillStar(newValue)
        buttonStar4.shouldFillStar(false)
        buttonStar5.shouldFillStar(false)
        rating = 3
    }
    
    @IBAction func onClickButtonStar4(_ sender: VDStarButton) {
        var newValue = !sender.shouldFillColor
        if newValue == false && buttonStar5.shouldFillColor {
            newValue = true
        }
        sender.shouldFillStar(newValue)
        buttonStar1.shouldFillStar(newValue)
        buttonStar2.shouldFillStar(newValue)
        buttonStar3.shouldFillStar(newValue)
        buttonStar5.shouldFillStar(false)
        rating = 4
    }
    
    @IBAction func onClickButtonStar5(_ sender: VDStarButton) {
        let newValue = !sender.shouldFillColor
        sender.shouldFillStar(newValue)
        buttonStar1.shouldFillStar(newValue)
        buttonStar2.shouldFillStar(newValue)
        buttonStar3.shouldFillStar(newValue)
        buttonStar4.shouldFillStar(newValue)
        rating = 5
    }
    
    @IBAction func onClickButtonSend(_ sender: UIButton) {
        
        VDLoadingView.shared.display(view: view)
        VDVoxboneManager.shared.postRatingToVoxbone(NSNumber(value: 5), andComments: textViewMessage.text, andResponse: { (result: String?, error: Error?) in
            VDLoadingView.shared.hide()
            self.presentingViewController?.dismiss(animated: true, completion: {
                if error != nil {
                    let alert = UIAlertController(title:"Error", message:error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
                    self.presentingViewController?.present(alert, animated: true, completion: nil)
                }
            })
        })
        
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
