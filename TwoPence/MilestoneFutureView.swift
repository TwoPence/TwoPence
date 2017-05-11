//
//  MilestoneFutureView.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/6/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

@objc protocol MilestoneFutureViewDelegate {
    @objc optional func didTapCloseButton()
    @objc optional func doJolt()
}

class MilestoneFutureView: UIView {
    
    var pgBar: CustomProgressBar?
    var debtMilestone: DebtMilestone?{
        didSet {
            setupView()
            self.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var milestoneFutureLabel: UILabel!
    @IBOutlet weak var barContainer: UIView!
    @IBOutlet weak var joltButton: UIButton!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var goalValue: UILabel!
    
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
        joltButton.layer.cornerRadius = 5
        
        topView.backgroundColor = AppColor.DarkGreen.color
        joltButton.backgroundColor = AppColor.DarkGreen.color
        setMilestoneProgress()
        addSubview(contentView)
    }
    
    @IBAction func onCloseTap(_ sender: Any) {
        delegate?.didTapCloseButton!()
    }
    
    @IBAction func doJolt(_ sender: Any) {
        delegate?.doJolt!()
    }
    
    func setupView(){
        if let milestone = debtMilestone {
            self.currentValue.text = milestone.current.formatted(withStyle: .currency)
            self.goalValue.text = "of \(String(describing: milestone.goal.formatted(withStyle: .currency)))"
            
            let diff = milestone.goal.subtracting(milestone.current)
            self.milestoneFutureLabel.text = "You are \(String(describing: diff.formatted(withStyle: .currency))) away from your next milestone!"
            
            let inc = (milestone.current.floatValue / milestone.goal.floatValue) * Double(barContainer.bounds.width)
            
            self.pgBar?.progress(incremented: CGFloat(inc))
        }
    }
    
    func setMilestoneProgress(){
        self.pgBar = CustomProgressBar(width: barContainer.bounds.width, height: barContainer.bounds.height)
        self.barContainer.addSubview(self.pgBar!)
        self.pgBar?.draw()
    }

}
