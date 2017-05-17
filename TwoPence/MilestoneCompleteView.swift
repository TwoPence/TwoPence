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

        milestoneCompleteImage.image = #imageLiteral(resourceName: "gift_white")
        shareButton.backgroundColor = AppColor.DarkSeaGreen.color
        
        Utils.setupGradientBackground(topColor: AppColor.DarkSeaGreen.color.cgColor, bottomColor: AppColor.MediumGreen.color.cgColor, view: topView)

        addSubview(contentView)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupViewData() {
        if let milestone = debtMilestone {
            // TODO Pass correct data
            let imageName = Utils.getMilestoneImageName(name: milestone.imageName)
            milestoneCompleteImage.image = UIImage(named: imageName)
            self.milestoneCompleteLabel.text = "Great job! 🙌 You have reached \(milestone.goal) milestone!!"
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        delegate?.didTapCloseButton!()
    }
    @IBAction func shareMilestone(_ sender: Any) {
        delegate?.shareMilestone!(shareText: milestoneCompleteLabel.text!)
    }
}
