//
//  Transaction.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money

class Transaction: NSObject {
    var amount: Money?
    var amountSaved: Money?
    var date: Date?
    var merchant: String?
    var status: String? //Should be enum
    var pending: Bool?
}