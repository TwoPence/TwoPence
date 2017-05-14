//
//  SavingsRate.swift
//  TwoPence
//
//  Created by Will Gilman on 5/5/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import Foundation
import Unbox

class SavingsRate: Unboxable {
    var dateEffective: Date
    var value: Decimal
    
    required init(unboxer: Unboxer) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        self.dateEffective = try unboxer.unbox(key: "date_effective", formatter: dateFormatter)
        
        let valueDouble: Double = try unboxer.unbox(key: "value")
        self.value = Decimal(valueDouble)
    }
}
