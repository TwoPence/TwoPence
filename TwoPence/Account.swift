//
//  Account.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money

class Account: NSObject {
    var name: String?
    var value: Money?
    var type: String? //Should be enum
    
    // REMOVE: Testing only
    init(name: String?, value: Money?, type: String?) {
        self.name = name
        self.value = value
        self.type = type
    }
}
