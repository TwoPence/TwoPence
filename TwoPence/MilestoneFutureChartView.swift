//
//  MilestoneFutureChartView.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/13/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class MilestoneFutureChartView: UIView {

    var pgBar: CustomProgressBar?
    var debtMilestone: DebtMilestone?{
        didSet {
            setupViewData()
        }
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var goalValue: UILabel!
    @IBOutlet weak var milestoneFutureLabel: UILabel!
    @IBOutlet weak var barContainer: UIView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "MilestoneFutureChartView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        setMilestoneProgressBar()
        addSubview(contentView)
    }
    
    func setupViewData(){
        if let milestone = debtMilestone {
            self.currentValue.text = milestone.current.formatted(withStyle: .currency)
            self.goalValue.text = "of \(String(describing: milestone.goal.formatted(withStyle: .currency)))"
            
            let diff = milestone.goal.subtracting(milestone.current)
            self.milestoneFutureLabel.text = "You are \(String(describing: diff.formatted(withStyle: .currency))) away from your next milestone!"
            
            let inc = (milestone.current.floatValue / milestone.goal.floatValue) * Double(barContainer.bounds.width)
            
            self.pgBar?.progress(incremented: CGFloat(inc))
        }
    }
    
    func setMilestoneProgressBar(){
        self.pgBar = CustomProgressBar(width: barContainer.bounds.width, height: barContainer.bounds.height)
        self.barContainer.addSubview(self.pgBar!)
        self.pgBar?.configure()
    }
}
