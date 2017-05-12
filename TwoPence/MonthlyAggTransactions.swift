//
//  MonthlyTotal.swift
//  TwoPence
//
//  Created by Will Gilman on 5/5/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import Foundation
import Money

class MonthlyAggTransactions {
    
    var month: String
    var monthAbbrev: String
    var monthInt: Int
    var amount: Money
    
    let dateFormatter = DateFormatter()
    
    init(month: String, amount: Money) {
        self.month = month
        self.monthAbbrev = month.substring(to: month.index(month.startIndex, offsetBy: 3))
        self.amount = amount
        
        dateFormatter.dateFormat = "MMM"
        let monthDate = dateFormatter.date(from: month)
        dateFormatter.dateFormat = "M"
        let monthInt = Int(dateFormatter.string(from: monthDate!))
        self.monthInt = monthInt!
        
    }
    
    class func withArray(aggTransactions: [AggTransactions]) -> [MonthlyAggTransactions] {
        
        var allMonths = [String]()
        for agg in aggTransactions {
            allMonths.append(agg.month!)
        }
        
        var monthlyTotals = [MonthlyAggTransactions]()
        let months = Set<String>(allMonths)
        
        for month in months {
            let amounts = aggTransactions.filter({$0.month == month}).map({$0.amount}) as! [Money]
            let total = amounts.reduce(0, +)
            monthlyTotals.append(MonthlyAggTransactions(month: month, amount: total))
        }
        return monthlyTotals.sorted(by: { $0.monthInt < $1.monthInt })
    }
}
