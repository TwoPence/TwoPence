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

class Transaction: Unboxable {
    var amount: Money?
    var amountSaved: Money?
    var date: Date?
    var merchant: String?
    var status: String? //Should be enum
    var pending: Bool?
    
    required init(unboxer: Unboxer) throws {
        let amountDouble: Double = try unboxer.unbox(key: "amount")
        self.amount = Money(amountDouble)
        
        let amountSavedDouble: Double = try unboxer.unbox(key: "amount_saved")
        self.amountSaved = Money(amountSavedDouble)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        self.date = unboxer.unbox(key: "date", formatter: dateFormatter)
        
        self.merchant = unboxer.unbox(key: "merchant")
        self.status = unboxer.unbox(key: "status")
        self.pending = unboxer.unbox(key: "pending")
    }
    
    init(amount: Money?, amountSaved: Money?, date: Date?, merchant: String?, status: String?, pending: Bool?) {
        self.amount = amount
        self.amountSaved = amountSaved
        self.date = date
        self.merchant = merchant
        self.status = status
        self.pending = pending
    }
}
