//
//  Account.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Unbox

class Account: Unboxable {
    var name: String?
    var value: String?
    var type: String? //Should be enum?
    
    required init(unboxer: Unboxer) throws {
        self.name = unboxer.unbox(key: "name")
        self.value = unboxer.unbox(key: "value")
        self.type = unboxer.unbox(key: "type")
    }
    
    class func  withArray(dictionaries: [Dictionary<String, Any>]) throws -> [Account] {
        var accounts = [Account]()
        
        for dict in dictionaries {
            let account: Account = try unbox(dictionary: dict)
            accounts.append(account)
        }
        
        return accounts
    }
}
