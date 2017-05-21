//
//  UserFinMetrics.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Unbox

class UserFinMetrics: Unboxable {

    var totalSaved: Double
    var loanRepaid: Double
    var interestAvoided: Double
    var daysOffLoanTerm: Int
    var loanTermInDaysWithTp: Int
    var loanTermInDaysWithoutTp: Int
    var loanTermInDaysAtEnrollment: Int
    var amountInvested: Double
    var totalReturn: Double
    
    required init(unboxer: Unboxer) throws {
        self.totalSaved = try unboxer.unbox(key: "total_saved")
        self.loanRepaid = try unboxer.unbox(key: "loan_repaid")
        self.interestAvoided = try unboxer.unbox(key: "interest_avoided")
        self.daysOffLoanTerm = try unboxer.unbox(key: "days_off_loan_term")
        self.loanTermInDaysWithTp = try unboxer.unbox(key: "loan_term_in_days_with_tp")
        self.loanTermInDaysWithoutTp = try unboxer.unbox(key: "loan_term_in_days_without_tp")
        self.loanTermInDaysAtEnrollment = try unboxer.unbox(key: "loan_term_in_days_at_enrollment")
        self.amountInvested = try unboxer.unbox(key: "amount_invested")
        self.totalReturn = try unboxer.unbox(key: "total_return")
    }
}
