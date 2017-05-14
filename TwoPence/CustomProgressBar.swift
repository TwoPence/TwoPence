//
//  CustomProgressBar.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/10/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class CustomProgressBar: UIView {
    
    var viewCornerRadius : CGFloat = 5
    var color = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00).cgColor
    var progressColor = UIColor(red:0.17, green:0.76, blue:0.62, alpha:1.00).cgColor
    var borderLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    
    
    public init(width: CGFloat, height: CGFloat, color: CGColor? = nil, progressColor: CGColor? = nil, cornerRadius: CGFloat?=nil){
        if let radius = cornerRadius {
            viewCornerRadius = radius
        }
        
        if let isColor = color {
            self.color = isColor
        }
        
        if let isProgressColor = color {
            self.progressColor = isProgressColor
        }
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure() {
        let bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: viewCornerRadius)
        bezierPath.close()
        borderLayer.path = bezierPath.cgPath
        borderLayer.fillColor = color
        borderLayer.strokeEnd = 0
        layer.addSublayer(borderLayer)
        
        let fromPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 0, height: bounds.height), cornerRadius: viewCornerRadius)
        progressLayer.path = fromPath.cgPath
        progressLayer.fillColor = progressColor
        borderLayer.addSublayer(progressLayer)
    }
    
    func progress(incremented: CGFloat) {
        if incremented <= bounds.width {
            let toPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: incremented, height: bounds.height), cornerRadius: viewCornerRadius)
            
            let fromPath = progressLayer.path
            progressLayer.path = toPath.cgPath
            borderLayer.addSublayer(progressLayer)
            
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = fromPath
            animation.toValue = toPath.cgPath
            animation.duration = 0.5
            progressLayer.add(animation, forKey: animation.keyPath)
        }
    }
}
