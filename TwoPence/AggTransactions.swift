//
//  AggTransactions.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money

class AggTransactions: NSObject {
    var amount: Money?
    var date: Date?
    var transactions: [Transaction]?
    var aggType: String? //Should be enum: Pending, Transfer, Unassigned
}
