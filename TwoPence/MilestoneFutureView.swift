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
    var debtMilestone: DebtMilestone? {
        didSet {
            setupViewData()
        }
    }
    var increment: CGFloat!
    var animateProgress: Bool! {
        didSet {
            incrementProgress()
        }
    }
    var withDuration: CFTimeInterval = 1.0

    @IBOutlet weak var milestoneNextImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var joltButton: UIButton!
    @IBOutlet weak var currentValue: EFCountingLabel!
    @IBOutlet weak var goalValue: UILabel!
    @IBOutlet weak var barContainer: UIView!
    @IBOutlet weak var milestoneFutureLabel: EFCountingLabel!
    
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
        addSubview(contentView)
        
        Utils.setupGradientBackground(topColor: AppColor.MediumGray.color.cgColor, bottomColor: AppColor.PaleGray.color.cgColor, view: topView)
        formatDisplay()
        setMilestoneProgressBar()
    }
    
    func formatDisplay() {
        joltButton.backgroundColor = AppColor.DarkSeaGreen.color
        joltButton.layer.cornerRadius = 4
        joltButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
        joltButton.titleLabel?.textColor = UIColor.white
        currentValue.textColor = AppColor.Charcoal.color
        currentValue.font = UIFont(name: AppFontName.light, size: 28)
        currentValue.formatBlock = { (value) in return Double(value).money(round: true) }
        goalValue.textColor = AppColor.MediumGray.color
        goalValue.font = UIFont(name: AppFontName.regular, size: 15)
        milestoneFutureLabel.textColor = AppColor.Charcoal.color
        milestoneFutureLabel.font = UIFont(name: AppFontName.regular, size: 17)
        milestoneFutureLabel.formatBlock = {
            (value) in
            return "You are " + Double(value).money(round: true) + " away from your next milestone!"
        }
    }
    
    @IBAction func onCloseTap(_ sender: Any) {
        delegate?.didTapCloseButton!()
    }
    
    @IBAction func doJolt(_ sender: Any) {
        delegate?.doJolt!()
    }
    
    func setupViewData(){
        if let milestone = debtMilestone {
            currentValue.text = milestone.priorGoal.money(round: true)
            goalValue.text = "of " + milestone.goal.money(round: true)
            let range = milestone.goal - milestone.priorGoal
            milestoneFutureLabel.countFromZeroTo(CGFloat(range), withDuration: 0.0)
            
            let inc = (milestone.current / milestone.goal) * Double(barContainer.bounds.width)
            increment = CGFloat(inc)
            
            let imageName = Utils.getMilestoneImageName(name: milestone.imageName)
            milestoneNextImage.image = UIImage(named: imageName)
        }
    }
    
    func incrementProgress() {
        if let milestone = debtMilestone {
            let range = milestone.goal - milestone.priorGoal
            let diff = milestone.goal - milestone.current
            milestoneFutureLabel.countFrom(CGFloat(range), to: CGFloat(diff), withDuration: withDuration)
            currentValue.countFrom(CGFloat(milestone.priorGoal), to: CGFloat(milestone.current), withDuration: withDuration)
        }
        pgBar.progress(incremented: increment, withDuration: withDuration)
    }
    
    func setMilestoneProgressBar(){
        pgBar = CustomProgressBar(width: barContainer.bounds.width, height: barContainer.bounds.height)
        barContainer.addSubview(self.pgBar)
        pgBar.configure()
    }
}
