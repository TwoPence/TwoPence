//
//  AssetView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class AssetView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "AssetView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        headerView.backgroundColor = UIColor.clear
        
        setupGradientBackground()
    }
    
    func setupGradientBackground() {
        let topColor = AppColor.MediumGray.color.cgColor
        let bottomColor = AppColor.PaleGray.color.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.2, 1.0]
        gradientLayer.frame = headerView.frame
        headerView.layer.insertSublayer(gradientLayer, at: 0)
    }

}
