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
    var borderLayer : CAShapeLayer = CAShapeLayer()
    let progressLayer : CAShapeLayer = CAShapeLayer()
    
    
    public init(width: CGFloat, height: CGFloat, color: CGColor?=nil, progressColor: CGColor?=nil, cornerRadius: CGFloat?=nil){
        if let radius = cornerRadius {
            self.viewCornerRadius = radius
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
    
    func draw(){
        let bezierPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: viewCornerRadius)
        bezierPath.close()
        borderLayer.path = bezierPath.cgPath
        borderLayer.fillColor = self.color
        borderLayer.strokeEnd = 0
        self.layer.addSublayer(borderLayer)
    }
    
    func progress(incremented : CGFloat){
        if incremented <= self.bounds.width{
            UIView.animate(withDuration: 0.5, animations: {
                self.progressLayer.removeFromSuperlayer()
                let bezierPathProg = UIBezierPath(roundedRect: CGRect(x:0, y:0, width:incremented , height:self.bounds.height) , cornerRadius: self.viewCornerRadius)
                bezierPathProg.close()
                self.progressLayer.path = bezierPathProg.cgPath
                self.progressLayer.fillColor = self.progressColor
                self.borderLayer.addSublayer(self.progressLayer)
            })
        }
    }
}
