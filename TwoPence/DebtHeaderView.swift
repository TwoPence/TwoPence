//
//  DebtHeaderView.swift
//  TwoPence
//
//  Created by Will Gilman on 5/10/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money

class DebtHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var horizontalDividerView: UIView!
    @IBOutlet weak var verticalDividerView: UIView!
    
    @IBOutlet weak var loanRepaidLabel: UILabel!
    @IBOutlet weak var interestAvoidedLabel: UILabel!
    @IBOutlet weak var daysOffLabel: UILabel!
    
    @IBOutlet weak var loanRepaidDeltaLabel: UILabel!
    @IBOutlet weak var interestAvoidedDeltaLabel: UILabel!
    @IBOutlet weak var daysOffDeltaLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "DebtHeaderView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        verticalDividerView.backgroundColor = AppColor.MediumGreen.color
        horizontalDividerView.backgroundColor = AppColor.MediumGreen.color
        
        loanRepaidDeltaLabel.alpha = 0.0
        interestAvoidedDeltaLabel.alpha = 0.0
        daysOffDeltaLabel.alpha = 0.0
    }
    
    var userFinMetrics: UserFinMetrics? {
        didSet {
            if let userFinMetrics = userFinMetrics {
                loanRepaidLabel.text = "\(userFinMetrics.loanRepaid)"
                interestAvoidedLabel.text = "\(userFinMetrics.interestAvoided)"
                daysOffLabel.text = userFinMetrics.daysOffLoanTerm.toLCD()
            }
        }
    }
    
    var loanRepaidDelta: Money? {
        didSet {
            if let userFinMetrics = userFinMetrics {
                loanRepaidLabel.text = "\(userFinMetrics.loanRepaid.adding(loanRepaidDelta!))"
                loanRepaidDeltaLabel.text = "+\(loanRepaidDelta!)"
                loanRepaidDeltaLabel.alpha = 1.0
            }
        }
    }
    
    var interestAvoidedDelta: Money? {
        didSet {
            if let userFinMetrics = userFinMetrics {
                interestAvoidedLabel.text = "\(userFinMetrics.interestAvoided.adding(interestAvoidedDelta!))"
                interestAvoidedDeltaLabel.text = "+\(interestAvoidedDelta!)"
                interestAvoidedDeltaLabel.alpha = 1.0
            }
        }
        
    }
    
    var daysOffDelta: Int? {
        didSet {
            if let userFinMetrics = userFinMetrics {
                let newDays = userFinMetrics.daysOffLoanTerm + daysOffDelta!
                daysOffLabel.text = "\(newDays.toLCD())"
                let units = daysOffDelta == 1 ? "day" : "days"
                daysOffDeltaLabel.text = "+\(daysOffDelta!) \(units)"
                daysOffDeltaLabel.alpha = 1.0
            }
        }
    }
}
