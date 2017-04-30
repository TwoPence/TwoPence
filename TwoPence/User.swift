//
//  User.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Cely

class User: CelyUser {
    
    enum Property: CelyProperty {
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "email"
        case profileUrl = "profileUrl"
        case phone = "phone"
        case savingRates = "savingRates"
        
        // Addr
        case streetAddr = "streetAddr"
        case cityAddr = "cityAddr"
        case stateAddr = "stateAddr"
        case zipAddr = "zipAddr"
        case countryAddr = "countryAddr"
        
        case token = "token"
        
        func securely() -> Bool {
            switch self {
            case .token:
                return true
            default:
                return false
            }
        }
        
        func persisted() -> Bool {
            switch self {
            case .email:
                return true
            default:
                return false
            }
        }
        
        func save(_ value: Any) {
            Cely.save(value, forKey: rawValue, securely: securely(), persisted: persisted())
        }
        
        func get() -> Any? {
            return Cely.get(key: rawValue)
        }
    }
}

// MARK: - Save/Get User Properties

extension User {
    
    static func save(_ value: Any, as property: Property) {
        property.save(value: value)
    }
    
    static func save(_ data: [Property : Any]) {
        data.forEach { property, value in
            property.save(value)
        }
    }
    
    static func get(_ property: Property) -> Any? {
        return property.get()
    }
}
