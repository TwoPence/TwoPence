//
//  SavingsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

@objc protocol SavingsViewDelegate {
    
    @objc optional func didTapJoltButton(didTap: Bool)
}

class SavingsView: UIView, JoltViewDelegate {

    @IBOutlet var contentView: UIView!
    
    weak var delegate: SavingsViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "SavingsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    @IBAction func onJoltTap(_ sender: UIButton) {
        delegate?.didTapJoltButton?(didTap: true)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
