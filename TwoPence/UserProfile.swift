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
    var firstName: String
    var lastName: String
    
    var email: String
    var profileUrl: String?
    var phone: String
    var savingsRates: [SavingsRate]?
    
    // Addr
    var streetAddr: String?
    var cityAddr: String?
    var stateAddr: String?
    var zipAddr: String?
    
    required init(unboxer: Unboxer) throws {
        self.firstName = try unboxer.unbox(key: "first_name")
        self.lastName = try unboxer.unbox(key: "last_name")
        self.email = try unboxer.unbox(key: "email")
        self.phone = try unboxer.unbox(key: "phone")

        self.savingsRates = unboxer.unbox(key: "saving_rates")
        self.streetAddr = unboxer.unbox(key: "address")
        self.cityAddr = unboxer.unbox(key: "city")
        self.stateAddr = unboxer.unbox(key: "state")
        self.zipAddr = unboxer.unbox(key: "postal_code")
    }
}
