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
    
    var debtMilestone: DebtMilestone?{
        didSet {
            setupViewData()
        }
    }
    
    @IBOutlet weak var milestoneCompleteImage: UIImageView!
    @IBOutlet weak var milestoneCompleteLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var shareButton: UIButton!

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
        shareButton.layer.cornerRadius = 4
        shareButton.backgroundColor = AppColor.DarkGreen.color
        topView.backgroundColor = AppColor.DarkGreen.color
        addSubview(contentView)
    }
    
    func setupViewData() {
        if let milestone = debtMilestone {
            // TODO Pass correct data
            self.milestoneCompleteLabel.text = "Great job! You have reached \(milestone.goal) milestone! \n \n \n By reaching this milestone you have avoided \(milestone.current) on interest and taken \(milestone.current) days off your debt :)"
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        delegate?.didTapCloseButton!()
    }
    @IBAction func shareMilestone(_ sender: Any) {
        delegate?.shareMilestone!(shareText: milestoneCompleteLabel.text!)
    }
}
