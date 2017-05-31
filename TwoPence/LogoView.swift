//
//  LogoView.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import IBAnimatable

class LogoView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var twoPenceLogo: AnimatableImageView!
    @IBOutlet weak var twoLabel: AnimatableLabel!
    @IBOutlet weak var penceLabel: AnimatableLabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "LogoView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        penceLabel.textColor = AppColor.MediumGreen.color
    }
}
