//
//  VDStarButton.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 4/11/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import UIKit

class VDStarButton: UIButton {
    
    let size: CGFloat = 30
    let lineWidth: CGFloat = 1
    let borderColor = UIColor.white
    let fillColor = VDConstants.Color.violet
    var path: UIBezierPath!
    var shouldFillColor: Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let insetRect = self.bounds.insetBy(dx: lineWidth, dy: lineWidth)
        self.path = starPathInRect(insetRect)
        
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        
        if !shouldFillColor {
            borderColor.setFill()
            fillColor.setStroke()
        } else {
            fillColor.setFill()
            fillColor.setStroke()
        }
        
        self.path.fill()
        
        path.lineWidth = lineWidth
        
        path.stroke()
    }
    
    func starPathInRect(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let starExtrusion:CGFloat = 6.0
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        let pointsOnStar = 5
        
        var angle:CGFloat = -CGFloat(Double.pi / 2.0)
        let angleIncrement = CGFloat(Double.pi * 2.0 / Double(pointsOnStar))
        let radius = rect.width / 2.0
        
        var firstPoint = true
        
        for _ in 1...pointsOnStar {
            
            let point = pointFrom(angle, radius: radius, offset: center)
            let nextPoint = pointFrom(angle + angleIncrement, radius: radius, offset: center)
            let midPoint = pointFrom(angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
            
            if firstPoint {
                firstPoint = false
                path.move(to: point)
            }
            
            path.addLine(to: midPoint)
            path.addLine(to: nextPoint)
            
            angle += angleIncrement
        }
        
        path.close()
        
        return path
    }
    
    func pointFrom(_ angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }
    
    func shouldFillStar(_ shouldFill: Bool) {
        shouldFillColor = shouldFill
        setNeedsDisplay()
    }
}

