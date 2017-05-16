//
//  UserFinMetrics.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money
import Unbox

class UserFinMetrics: Unboxable {

    var totalSaved: Money
    var loanRepaid: Money
    var interestAvoided: Money
    var daysOffLoanTerm: Int
    var loanTermInDaysWithTp: Int
    var loanTermInDaysWithoutTp: Int
    var loanTermInDaysAtEnrollment: Int
    var amountInvested: Money
    var totalReturn: Decimal
    
    required init(unboxer: Unboxer) throws {
        let totalSavedDouble: Double = try unboxer.unbox(key: "total_saved")
        self.totalSaved = Money(totalSavedDouble)
        
        let loanRepaidDouble: Double = try unboxer.unbox(key: "loan_repaid")
        self.loanRepaid = Money(loanRepaidDouble)
        
        let interestAvoidedDouble: Double = try unboxer.unbox(key: "interest_avoided")
        self.interestAvoided = Money(interestAvoidedDouble)
        
        self.daysOffLoanTerm = try unboxer.unbox(key: "days_off_loan_term")
        self.loanTermInDaysWithTp = try unboxer.unbox(key: "loan_term_in_days_with_tp")
        self.loanTermInDaysWithoutTp = try unboxer.unbox(key: "loan_term_in_days_without_tp")
        self.loanTermInDaysAtEnrollment = try unboxer.unbox(key: "loan_term_in_days_at_enrollment")
        
        let amountInvestedDouble: Double = try unboxer.unbox(key: "amount_invested")
        self.amountInvested = Money(amountInvestedDouble)
        
        let totalReturnDouble: Double = try unboxer.unbox(key: "total_return")
        self.totalReturn = Decimal(totalReturnDouble)
    }
}
