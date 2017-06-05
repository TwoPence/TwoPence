//
//  Sponsor.swift
//  TwoPence
//
//  Created by Will Gilman on 5/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import Foundation
import Unbox

enum FreqEnum: String, UnboxableEnum {
    case Monthly
    case Annually
}

class Sponsor: Unboxable {
    var name: String
    var email: String
    var isPayingFee: Bool
    var isMatching: Bool
    var matchRate: Double
    var matchFreq: FreqEnum?
    var matchLimit: Double?
    var totalMatchedAmount: Double
    
    required init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(key: "name")
        self.email = try unboxer.unbox(key: "email")
        self.isPayingFee = try unboxer.unbox(key: "is_paying_fee")
        self.isMatching = try unboxer.unbox(key: "is_matching")
        self.matchRate = try unboxer.unbox(key: "match_rate")
        self.matchFreq = unboxer.unbox(key: "match_freq")
        self.matchLimit = unboxer.unbox(key: "match_limit")
        self.totalMatchedAmount = try unboxer.unbox(key: "total_matched_amount")
    }
    
    class func  withArray(dictionaries: [Dictionary<String, Any>]) throws -> [Sponsor] {
        var sponsors = [Sponsor]()
        
        for dict in dictionaries {
            let sponsor: Sponsor = try unbox(dictionary: dict)
            sponsors.append(sponsor)
        }
        
        return sponsors
    }
}
