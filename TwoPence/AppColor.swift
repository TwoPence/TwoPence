//
//  AppColor.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/10/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

enum AppColor: UInt32 {
    
    case DarkSeaGreen = 0x169b62
    case MediumGreen = 0x57cd90
    case PaleGreen = 0xc1e6d5
    case Charcoal = 0x1d2323
    case MediumGray = 0x939fae
    case PaleGray = 0xf4f5f6
    case Red = 0xd14836
    
    case DarkGray = 0x383A35
    case LightGreen = 0x42B580
    case LightBlueGray = 0xD0DBE6

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
