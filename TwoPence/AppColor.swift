//
//  AppColor.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/10/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

enum AppColor: UInt32 {
    
    case SplashColor = 0x239964
    case Charcoal = 0x1D2323
    case LightGray = 0x939FAE
    case ExtraLightGray = 0xF4F5F6
    case DarkGreen = 0x34AB74
    case ProgressBar = 0x36C19E
    case PaleRed = 0xd14836

    var color: UIColor {
        return UIColor(hex: rawValue)
    }
}

extension UIColor {
    public convenience init(hex: UInt32) {
        let mask = 0x000000FF
        
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
}
