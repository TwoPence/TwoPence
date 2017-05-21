//
//  DoubleExtensions.swift
//  TwoPence
//
//  Created by Will Gilman on 5/20/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import Foundation

extension Double {
    
    func money(round: Bool? = nil) -> String {
        
        var result: String
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        if round ?? false {
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            result = formatter.string(from: NSNumber(value: Int(self))) ?? "n/a"
        } else {
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            result = formatter.string(from: NSNumber(value: self)) ?? "n/a"
        }
        
        return result
    }
}
