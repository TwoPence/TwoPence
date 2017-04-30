//
//  AggTransactions.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money
import Unbox

class AggTransactions: Unboxable {
    var amount: Money?
    var date: Date?
    var transactions: [Transaction]?
    var aggType: String? //Should be enum: Pending, Transfer, Unassigned
    
    required init(unboxer: Unboxer) throws {
        let amountDouble: Double = try unboxer.unbox(key: "amount")
        self.amount = Money(amountDouble)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        self.date = unboxer.unbox(key: "date", formatter: dateFormatter)
        self.transactions = unboxer.unbox(key: "transactions")
        self.aggType = unboxer.unbox(key: "aggType")
    }
    
    class func  withArray(dictionaries: [Dictionary<String, Any>]) throws -> [AggTransactions] {
        var aggTransactions = [AggTransactions]()
        
        for dict in dictionaries {
            let aggTx: AggTransactions = try unbox(dictionary: dict)
            aggTransactions.append(aggTx)
        }
        
        return aggTransactions
    }
    
}
