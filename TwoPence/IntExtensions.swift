//
//  IntExtensions.swift
//  TwoPence
//
//  Created by Will Gilman on 5/16/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import Foundation

extension Int {
    
    func toLCD() -> String {
        
        let days = self
        let years = days / 365
        let yearRemainderDays = days % 365
        let months = yearRemainderDays / 30
        let monthRemainderDays = yearRemainderDays % 30
        
        let yearString = years == 0 ? "" : "\(years) yr "
        let monthString = months == 0 ? "" : "\(months) mo "
        let dayString = "\(monthRemainderDays) day\(pluralize(count: monthRemainderDays))"
        
        return yearString + monthString + dayString
    }
    
    private func pluralize(count: Int) -> String {
        return count == 1 ? "" : "s"
    }
}
