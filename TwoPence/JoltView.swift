//
//  JoltView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

@objc protocol JoltViewDelegate {
    
    @objc optional func didTapCloseButton(didTap: Bool)
}

class JoltView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    weak var delegate: JoltViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "JoltView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    @IBAction func onDecreaseTap(_ sender: UIButton) {
    }
    
    @IBAction func onIncreaseTap(_ sender: UIButton) {
    }
    
    @IBAction func onJoltTap(_ sender: UIButton) {
    }
    
    @IBAction func onCloseTap(_ sender: UIButton) {
        delegate?.didTapCloseButton?(didTap: true)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
