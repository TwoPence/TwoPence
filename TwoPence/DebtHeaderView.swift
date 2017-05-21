//
//  DebtHeaderView.swift
//  TwoPence
//
//  Created by Will Gilman on 5/10/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import EFCountingLabel

class DebtHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var horizontalDividerView: UIView!
    @IBOutlet weak var verticalDividerView: UIView!
    
    @IBOutlet weak var loanRepaidLabel: EFCountingLabel!
    @IBOutlet weak var interestAvoidedLabel: EFCountingLabel!
    @IBOutlet weak var daysOffLabel: UILabel!
    
    @IBOutlet weak var loanRepaidDeltaLabel: EFCountingLabel!
    @IBOutlet weak var interestAvoidedDeltaLabel: EFCountingLabel!
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
        
        loanRepaidLabel.formatBlock = { (value) in return Double(value).money(round: true) }
        loanRepaidDeltaLabel.formatBlock = { (value) in return Double(value).money(round: true) }
        interestAvoidedLabel.formatBlock = { (value) in return Double(value).money() }
        interestAvoidedDeltaLabel.formatBlock = { (value) in return Double(value).money() }
        
        loanRepaidDeltaLabel.alpha = 0.0
        interestAvoidedDeltaLabel.alpha = 0.0
        daysOffDeltaLabel.alpha = 0.0
    }
    
    var currentLoanRepaid: CGFloat = 0
    var currentInterestAvoided: CGFloat = 0
    var currentLoanRepaidDelta: CGFloat = 20
    var currentInterestAvoidedDelta: CGFloat = 0
    let withDuration: CFTimeInterval = 0.2
    
    var userFinMetrics: UserFinMetrics? {
        didSet {
            if let userFinMetrics = userFinMetrics {
                currentLoanRepaid = CGFloat(userFinMetrics.loanRepaid)
                currentInterestAvoided = CGFloat(userFinMetrics.interestAvoided)
                
                loanRepaidLabel.countFromZeroTo(currentLoanRepaid, withDuration: 0.0)
                interestAvoidedLabel.countFromZeroTo(currentInterestAvoided, withDuration: 0.0)
                daysOffLabel.text = userFinMetrics.daysOffLoanTerm.toLCD()
            }
        }
    }
    
    var loanRepaidDelta: Double? {
        didSet {
            let newLoanRepaidDelta = CGFloat(loanRepaidDelta!)
            let newLoanRepaid = currentLoanRepaid + newLoanRepaidDelta
            
            loanRepaidLabel.countFrom(currentLoanRepaid, to: newLoanRepaid, withDuration: withDuration)
            loanRepaidDeltaLabel.countFrom(currentLoanRepaidDelta, to: newLoanRepaidDelta, withDuration: withDuration)
            loanRepaidDeltaLabel.alpha = 1.0
            
            currentLoanRepaidDelta = newLoanRepaidDelta
        }
    }
    
    var interestAvoidedDelta: Double? {
        didSet {
            let newInterestAvoidedDelta = CGFloat(interestAvoidedDelta!)
            let newInterestAvoided = currentInterestAvoided + newInterestAvoidedDelta
            
            interestAvoidedLabel.countFrom(currentInterestAvoided, to: newInterestAvoided, withDuration: withDuration)
            interestAvoidedDeltaLabel.countFrom(currentInterestAvoidedDelta, to: newInterestAvoidedDelta, withDuration: withDuration)
            interestAvoidedDeltaLabel.alpha = 1.0
            
            currentInterestAvoidedDelta = newInterestAvoidedDelta
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
