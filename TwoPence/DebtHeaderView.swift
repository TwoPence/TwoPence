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
    
    @IBOutlet weak var loanRepaidDeltaLabel: EFCountingLabel!
    @IBOutlet weak var interestAvoidedDeltaLabel: EFCountingLabel!
    
    @IBOutlet weak var yearsOffLabel: EFCountingLabel!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var monthsOffLabel: EFCountingLabel!
    @IBOutlet weak var monthsLabel: UILabel!
    @IBOutlet weak var daysOffLabel: EFCountingLabel!
    @IBOutlet weak var daysLabel: UILabel!
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

        setupLabels()
    }
    
    func setupLabels() {
        yearsOffLabel.format = "%d"
        monthsOffLabel.format = "%d"
        daysOffLabel.format = "%d"
        loanRepaidLabel.formatBlock = { (value) in return Double(value).money(round: true) }
        loanRepaidDeltaLabel.formatBlock = { (value) in return "+" + Double(value).money(round: true) }
        interestAvoidedLabel.formatBlock = { (value) in return Double(value).money(round: true) }
        interestAvoidedDeltaLabel.formatBlock = { (value) in return "+" + Double(value).money(round :true) }
        loanRepaidDeltaLabel.alpha = 0.0
        interestAvoidedDeltaLabel.alpha = 0.0
        daysOffDeltaLabel.alpha = 0.0
        yearsOffLabel.isHidden = true
        yearsLabel.isHidden = true
        monthsOffLabel.isHidden = true
        monthsLabel.isHidden = true
    }
    
    var inJoltView: Bool = false
    var currentLoanRepaid: CGFloat = 0
    var currentInterestAvoided: CGFloat = 0
    var currentLoanRepaidDelta: CGFloat = 20
    var currentInterestAvoidedDelta: CGFloat = 0
    var currentYears: CGFloat = 0
    var currentMonths: CGFloat = 0
    var currentDays: CGFloat = 0
    let withDuration: CFTimeInterval = 0.2
    
    var userFinMetrics: UserFinMetrics? {
        didSet {
            if let userFinMetrics = userFinMetrics {
                currentLoanRepaid = CGFloat(userFinMetrics.loanRepaid)
                currentInterestAvoided = CGFloat(userFinMetrics.interestAvoided)
                
                // Set repaid, interest and days to their current values.
                if inJoltView {
                    let timeRecovered = userFinMetrics.daysOffLoanTerm.toLCD()
                    setTimeDisplay(timeRecovered: timeRecovered, withDuration: 0.0, withDelay: 0.0)
                }
                loanRepaidLabel.countFromZeroTo(currentLoanRepaid, withDuration: 0.0)
                interestAvoidedLabel.countFromZeroTo(currentInterestAvoided, withDuration: 0.0)
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
                setTimeDisplay(timeRecovered: newDays.toLCD(), withDuration: withDuration, withDelay: 0.0)
                let units = daysOffDelta == 1 ? "day" : "days"
                daysOffDeltaLabel.text = "+\(daysOffDelta!) \(units)"
                daysOffDeltaLabel.alpha = 1.0
            }
        }
    }
    
    // Setting the time display is complex because it is used in DebtView and JoltView. In DebtView, we want the time display to start counting once the 'With TwoPence' chart passes the 'Without TwoPence' chart. We need to wait for the 'Without TwoPence' chart to render (hence the withDelay argument) and then count the time recovered labels as the 'With TwoPence' chart renders. For JoltView, we want the time recovered to display immediately.
    func setTimeDisplay(timeRecovered: [Int], withDuration: CFTimeInterval, withDelay: CFTimeInterval) {
        let years = timeRecovered[0]
        let months = timeRecovered[1]
        let days = timeRecovered[2]
        
        Timer.schedule(delay: withDelay) { (_) in
            if years != 0 {
                self.yearsOffLabel.isHidden = false
                self.yearsLabel.isHidden = false
                self.yearsOffLabel.countFrom(self.currentYears, to: CGFloat(years), withDuration: withDuration)
            } else {
                self.yearsOffLabel.isHidden = true
                self.yearsLabel.isHidden = true
            }
                
            if months != 0 {
                self.monthsOffLabel.isHidden = false
                self.monthsLabel.isHidden = false
                self.monthsOffLabel.countFrom(self.currentMonths, to: CGFloat(months), withDuration: withDuration)
            } else {
                self.monthsOffLabel.isHidden = true
                self.monthsLabel.isHidden = true
            }
                
            self.daysOffLabel.countFrom(self.currentDays, to: CGFloat(days), withDuration: withDuration)
            
            self.currentYears = CGFloat(years)
            self.currentMonths = CGFloat(months)
            self.currentDays = CGFloat(days)
        }
    }
}
