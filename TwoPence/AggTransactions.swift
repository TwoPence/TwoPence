//
//  AggTransactions.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Unbox

enum AggType: String, UnboxableEnum {
    case Pending
    case Transfer
    case Matched
    case Jolt
}

class AggTransactions: Unboxable {
    var amount: Double
    var date: Date
    var month: String
    var transactions: [Transaction]
    var aggType: AggType
    
    required init(unboxer: Unboxer) throws {
        self.amount = try unboxer.unbox(key: "amount")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        self.date = try unboxer.unbox(key: "date", formatter: dateFormatter)
        dateFormatter.dateFormat = "MMMM"
        self.month = dateFormatter.string(from: self.date)
        self.transactions = try unboxer.unbox(key: "transactions")
        self.aggType = try unboxer.unbox(key: "agg_type")
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
