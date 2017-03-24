//
//  VDLoadingView.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/22/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import UIKit

class VDLoadingView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    // MARK: - # Singleton
    
    open static let shared = VDLoadingView(frame: CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        activityIndicator.center = center
        addSubview(activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func display(view: UIView) {
        view.addSubview(self)
        activityIndicator.startAnimating()
    }
    
    public func hide() {
        removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}
