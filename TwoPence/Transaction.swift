//
//  Transaction.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money
import Unbox

enum Status: String, UnboxableEnum {
    case Queued
    case Skipped
    case Processed
}

class Transaction: Unboxable {
    var amount: Money
    var amountSaved: Money
    var date: Date
    var merchant: String
    var status: Status
    var pending: Bool
    
    required init(unboxer: Unboxer) throws {
        let amountDouble: Double = try unboxer.unbox(key: "amount")
        self.amount = Money(amountDouble)
        
        let amountSavedDouble: Double = try unboxer.unbox(key: "amount_saved")
        self.amountSaved = Money(amountSavedDouble)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        self.date = try unboxer.unbox(key: "date", formatter: dateFormatter)
        
        self.merchant = try unboxer.unbox(key: "merchant")
        self.status = try unboxer.unbox(key: "status")
        self.pending = try unboxer.unbox(key: "pending")
    }

    class func groupByDate(transactions: [Transaction]) -> [(date: Date, transactions: [Transaction])] {
        var groupedTransactions = [(date: Date, transactions: [Transaction])]()
        var dates = [Date]()
        for trans in transactions {
            dates.append(trans.date)
        }
        let uniqueDates = Set<Date>(dates)
        for date in uniqueDates {
            let trans = transactions.filter({$0.date == date})
            groupedTransactions.append((date: date, transactions: trans.sorted(by: { $0.date > $1.date })))
        }
        return groupedTransactions.sorted(by: { $0.date > $1.date })
    }
    
}
