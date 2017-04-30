//
//  UserFinMetrics.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money

class UserFinMetrics: NSObject {

    var totalSaved: Money?
    var monthlyTotalSaved: [Date : Money]?
    var loanRepaid: Money?
    var interestAvoided: Money?
    var daysOffLoanTerm: Int?
    var loanTermInDaysWithTp: Int?
    var loanTermInDaysWithoutTp: Int?
    var amountInvested: Money?
    var totalReturn: Money?
    
}
