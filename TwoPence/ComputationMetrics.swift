//
//  ComputationMetrics.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money
import Unbox
import Foundation

class ComputationMetrics: Unboxable {
    
    var principal: Double?
    var monthlyPayment: Double?
    var annualInterestRate: Double?
    
    required init(unboxer: Unboxer) throws {
        let principalDouble: Double = try unboxer.unbox(key: "principal")
        self.principal = principalDouble
        
        let monthlyPaymentDouble: Double = try unboxer.unbox(key: "monthly_payment")
        self.monthlyPayment = monthlyPaymentDouble
        
        let annualInterestRateDouble: Double = try unboxer.unbox(key: "annual_interest_rate")
        self.annualInterestRate = annualInterestRateDouble
        
    }
    
    class func termReductionInDays(computationMetrics: ComputationMetrics, payment: Double) -> Int {
        
        let prePaymentTermInDays = termInDays(computationMetrics: computationMetrics, payment: nil)
        let postPaymentTermInDays = termInDays(computationMetrics: computationMetrics, payment: payment)
        
        return prePaymentTermInDays - postPaymentTermInDays
    }
    
    class func interestAvoided(computationMetrics: ComputationMetrics, payment: Double) -> Money {
        
        let annualPeriodDays: Double = 365.25
        let interestRateFactor = computationMetrics.annualInterestRate! / annualPeriodDays
        let principal = computationMetrics.principal!
        let newPrincipal = principal - payment
        
        let prePaymentTermInDays = termInDays(computationMetrics: computationMetrics, payment: nil)
        let postPaymentTermInDays = termInDays(computationMetrics: computationMetrics, payment: payment)
        let prePaymentCumulativeInterest = cumulativeInterestPayments(rate: interestRateFactor, nper: prePaymentTermInDays, presentValue: principal)
        let postPaymentCumulativeInterest = cumulativeInterestPayments(rate: interestRateFactor, nper: postPaymentTermInDays, presentValue: newPrincipal)
        
        let interestAvoided = prePaymentCumulativeInterest - postPaymentCumulativeInterest
        
        return Money(interestAvoided)
    }
    
    class func termInDays(computationMetrics: ComputationMetrics, payment: Double?) -> Int {
        let annualPeriodDays: Double = 365.25
        let interestRateFactor = computationMetrics.annualInterestRate! / annualPeriodDays
        let dailyPaymentEquivalent = computationMetrics.monthlyPayment! * 12.0 / annualPeriodDays
        let principal = computationMetrics.principal!
        let newPrincipal = principal - (payment ?? 0)
    
        let termInDays = log(-dailyPaymentEquivalent / (-dailyPaymentEquivalent + (newPrincipal * interestRateFactor))) / log(1 + interestRateFactor)
    
        return Int(termInDays)
    }
    
    class func cumulativeInterestPayments(rate: Double, nper: Int, presentValue: Double) -> Double {
        var balance: Double = presentValue
        var interest: Double = 0
        var cumulativeInterest: Double = 0
        var principal: Double
        let payment: Double = presentValue / ((1 - pow(1 + rate, Double(-nper))) / rate)
        
        for _ in 1...nper {
            interest = balance * rate
            principal = payment - interest
            balance = balance - principal
            cumulativeInterest = cumulativeInterest + interest
        }
        
        return cumulativeInterest
    }
    
}
