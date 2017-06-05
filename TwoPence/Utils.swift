//
//  Utils.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/16/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class Utils: NSObject {
    
    class func setupGradientBackground(topColor: CGColor, bottomColor: CGColor, view: UIView, frame: CGRect? = nil, index: UInt32? = nil) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.2, 1.0]
        gradientLayer.frame = frame ?? view.frame
        view.layer.insertSublayer(gradientLayer, at: index ?? 0)
    }
    
    class func getMilestoneImageName(name: String) -> String {
        var imageName = name
        if imageName == "fifteen_hundred" || imageName == "two_thousand" {
            imageName = "one_thousand"
        }
        
        return imageName
    }
    
    class func profileImageFromContact(contact: CNContact) -> UIImage? {
        let profileLabel = UILabel()
        profileLabel.frame.size = CGSize(width: 100.0, height: 100.0)
        profileLabel.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
        profileLabel.layer.borderWidth = 2.0
        profileLabel.layer.cornerRadius = 50
        profileLabel.font = UIFont(name: AppFontName.regular, size: 44)
        profileLabel.textColor = AppColor.DarkSeaGreen.color
        profileLabel.adjustsFontSizeToFitWidth = true
        profileLabel.textAlignment = .center
        let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "Two Pence"
        let initials = fullName.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.characters.first!)") + "\($1.characters.first!)" }
        profileLabel.text = initials
        
        UIGraphicsBeginImageContext(profileLabel.frame.size)
        profileLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        let profileImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return profileImage
    }
}
