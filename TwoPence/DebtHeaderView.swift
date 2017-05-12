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
        
        loanRepaidDeltaLabel.alpha = 0.0
        interestAvoidedDeltaLabel.alpha = 0.0
        daysOffDeltaLabel.alpha = 0.0
    }
    
    var userFinMetrics: UserFinMetrics? {
        didSet {
            if let loanRepaid = userFinMetrics?.loanRepaid {
                self.loanRepaidLabel.text = "\(loanRepaid)"
            }
            if let interestAvoided = userFinMetrics?.interestAvoided {
                self.interestAvoidedLabel.text = "\(interestAvoided)"
            }
            if let daysOff = userFinMetrics?.daysOffLoanTerm {
                self.daysOffLabel.text = "\(daysOff)"
            }
            self.layoutIfNeeded()
        }
    }
    
    var loanRepaidDelta: Money? {
        didSet {
            if let loan = userFinMetrics?.loanRepaid {
                loanRepaidLabel.text = "\(loan.adding(loanRepaidDelta!))"
                loanRepaidDeltaLabel.text = "+\(loanRepaidDelta!)"
                loanRepaidDeltaLabel.alpha = 1.0
                self.layoutIfNeeded()
            }
        }
    }
    
    var interestAvoidedDelta: Money? {
        didSet {
            if let interest = userFinMetrics?.interestAvoided {
                interestAvoidedLabel.text = "\(interest.adding(interestAvoidedDelta!))"
                interestAvoidedDeltaLabel.text = "+\(interestAvoidedDelta!)"
                interestAvoidedDeltaLabel.alpha = 1.0
                self.layoutIfNeeded()
            }
        }
        
    }
    
    var daysOffDelta: Int? {
        didSet {
            if let days = userFinMetrics?.daysOffLoanTerm {
                daysOffLabel.text = "\(days + daysOffDelta!)"
                daysOffDeltaLabel.text = "+\(daysOffDelta!) days"
                daysOffDeltaLabel.alpha = 1.0
                self.layoutIfNeeded()
            }
        }
    }
}
