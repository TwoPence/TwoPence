//
//  MilestoneFutureView.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/6/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import EFCountingLabel

@objc protocol MilestoneFutureViewDelegate {
    @objc optional func didTapCloseButton()
    @objc optional func doJolt()
}

class MilestoneFutureView: UIView {
    
    var pgBar: CustomProgressBar!
    var debtMilestone: DebtMilestone?{
        didSet {
            setupViewData()
        }
    }
    var increment: CGFloat!
    var animateProgressBar: Bool! {
        didSet {
            incrementProgressBar()
        }
    }

    @IBOutlet weak var milestoneNextImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var joltButton: UIButton!
    @IBOutlet weak var currentValue: EFCountingLabel!
    @IBOutlet weak var goalValue: UILabel!
    @IBOutlet weak var barContainer: UIView!
    @IBOutlet weak var milestoneFutureLabel: UILabel!
    
    weak var delegate: MilestoneFutureViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "MilestoneFutureView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        joltButton.layer.cornerRadius = 4
        
        milestoneNextImage.image = #imageLiteral(resourceName: "cup_white")
        
        Utils.setupGradientBackground(topColor: AppColor.DarkSeaGreen.color.cgColor, bottomColor: AppColor.MediumGreen.color.cgColor, view: topView)
        joltButton.backgroundColor = AppColor.DarkSeaGreen.color

        addSubview(contentView)
        setMilestoneProgressBar()
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func onCloseTap(_ sender: Any) {
        delegate?.didTapCloseButton!()
    }
    
    @IBAction func doJolt(_ sender: Any) {
        delegate?.doJolt!()
    }
    
    func setupViewData(){
        if let milestone = debtMilestone {
            currentValue.text = milestone.current.formatted(withStyle: .currency)

            goalValue.text = "of \(String(describing: milestone.goal.formatted(withStyle: .currency)))"
            
            let diff = milestone.goal.subtracting(milestone.current)
            milestoneFutureLabel.text = "You are \(String(describing: diff.formatted(withStyle: .currency))) away from your next milestone!"
            
            let inc = (milestone.current.floatValue / milestone.goal.floatValue) * Double(barContainer.bounds.width)
            increment = CGFloat(inc)
        }
    }
    
    func incrementProgressBar(){
        pgBar.progress(incremented: increment)
    }
    
    func setMilestoneProgressBar(){
        pgBar = CustomProgressBar(width: barContainer.bounds.width, height: barContainer.bounds.height)
        barContainer.addSubview(self.pgBar)
        pgBar.configure()
    }
}
