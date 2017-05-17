//
//  Utils.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/16/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class Utils: NSObject {
    class func setupGradientBackground(topColor: CGColor, bottomColor: CGColor, view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.2, 1.0]
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
