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
        case token = "token"
        
        func securely() -> Bool {
            switch self {
            case .token:
                return true
            }
        }
        
        func save(_ value: Any) {
            Cely.save(value, forKey: rawValue, securely: true)
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

