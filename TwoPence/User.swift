//
//  User.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class User: NSObject {
    var firstName: String?
    var lastName: String?
    
    var email: String?
    var profileUrl: String?
    var phone: String?
    var savingRates: [Double]?
    
    // Addr
    var streetAddr: String?
    var cityAddr: String?
    var stateAddr: String?
    var zipAddr: String?
    var countryAddr: String?
    
    var token: String? //Maybe handled by login lib
}
