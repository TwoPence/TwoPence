//
//  MilestoneCompleteView.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/6/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

@objc protocol MilestoneCompleteViewDelegate {
    @objc optional func didTapCloseButton()
    @objc optional func shareMilestone(shareText: String)
}

class MilestoneCompleteView: UIView {
    
    @IBOutlet weak var milestoneCompleteImage: UIImageView!
    @IBOutlet weak var milestoneCompleteLable: UILabel!
    @IBOutlet var contentView: UIView!
    
    var delegate: MilestoneCompleteViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "MilestoneCompleteView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    @IBAction func closeView(_ sender: Any) {
        delegate?.didTapCloseButton!()
    }
    @IBAction func shareMilestone(_ sender: Any) {
        delegate?.shareMilestone!(shareText: milestoneCompleteLable.text!)
    }
}
