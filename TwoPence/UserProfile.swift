//
//  UserProfile.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Unbox

class UserProfile: Unboxable {
    var firstName: String?
    var lastName: String?
    
    var email: String?
    var profileUrl: String?
    var phone: String?
    var savingRates = [Date : Decimal]()
    
    // Addr
    var streetAddr: String?
    var cityAddr: String?
    var stateAddr: String?
    var zipAddr: String?
    var countryAddr: String?
    
    required init(unboxer: Unboxer) throws {
        self.firstName = unboxer.unbox(key: "firstName")
        self.lastName = unboxer.unbox(key: "lastName")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let savingRatesString: [String : Decimal] = try unboxer.unbox(key: "savingRates")
        for (date, rate) in savingRatesString {
            self.savingRates[dateFormatter.date(from: date)!] = rate
        }
        
        self.streetAddr = unboxer.unbox(key: "streetAddr")
        self.cityAddr = unboxer.unbox(key: "cityAddr")
        self.stateAddr = unboxer.unbox(key: "stateAddr")
        self.zipAddr = unboxer.unbox(key: "zipAddr")
        self.countryAddr = unboxer.unbox(key: "countryAddr")
    }
}
