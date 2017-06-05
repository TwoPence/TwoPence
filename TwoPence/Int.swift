//
//  IntExtensions.swift
//  TwoPence
//
//  Created by Will Gilman on 5/16/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import Foundation

extension Int {
    
    func toLCD() -> [Int] {
        
        let years = self / 365
        let yearRemainderDays = self % 365
        let months = yearRemainderDays / 30
        let days = yearRemainderDays % 30
        
        return [years, months, days]
    }
}
