//
//  PeekingBenView.swift
//  TwoPence
//
//  Created by Will Gilman on 5/25/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class PeekingBenView: UIView {

    @IBOutlet var contentView: UIView!
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "PeekingBenView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }

}
