//
//  CustomProgressBar.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/10/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

enum CustomProgressBarFillDirection: Int {
    case right
    case left
}

class CustomProgressBar: UIView {
    
    var viewCornerRadius : CGFloat = 5
    var color = AppColor.PaleGray.color.cgColor
    var progressColor = AppColor.DarkSeaGreen.color.cgColor
    var borderLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    var fillDirection: CustomProgressBarFillDirection = .right
    
    
    public init(width: CGFloat, height: CGFloat, color: CGColor? = nil, progressColor: CGColor? = nil, cornerRadius: CGFloat? = nil, fillDirection: CustomProgressBarFillDirection? = nil){
        if let radius = cornerRadius {
            viewCornerRadius = radius
        }
        
        if let isColor = color {
            self.color = isColor
        }
        
        if let isProgressColor = progressColor {
            self.progressColor = isProgressColor
        }
        
        if let isFillDirection = fillDirection {
            self.fillDirection = isFillDirection
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
        
        let width = fillDirection == .right ? 0 : bounds.width
        let fromPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: bounds.height), cornerRadius: viewCornerRadius)
        progressLayer.path = fromPath.cgPath
        progressLayer.fillColor = progressColor
        
        borderLayer.addSublayer(progressLayer)
    }
    
    func progress(incremented: CGFloat, withDuration: CFTimeInterval? = nil) {
        if incremented <= bounds.width {
            
            let width = fillDirection == .right ? incremented : bounds.width - incremented
            let toPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: bounds.height), cornerRadius: viewCornerRadius)
            
            let fromPath = progressLayer.path
            progressLayer.path = toPath.cgPath
            
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = fromPath
            animation.toValue = toPath.cgPath
            animation.duration = withDuration ?? 0.5
            progressLayer.add(animation, forKey: animation.keyPath)
            
            borderLayer.addSublayer(progressLayer)
        }
    }
    
    func setupGradient() -> CAGradientLayer {
        let topColor = AppColor.PaleGreen.color.cgColor
        let bottomColor = AppColor.DarkSeaGreen.color.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.2, 1.0]
        return gradientLayer
    }
}
