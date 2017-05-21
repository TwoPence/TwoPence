//
//  Institution.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class Institution: NSObject {
    var name: String
    var logoUrl: String
    var accounts: [Account]
    
    // REMOVE: Testing only
    init(name: String, logoUrl: String, accounts: [Account]) {
        self.name = name
        self.logoUrl = logoUrl
        self.accounts = accounts
    }
}
