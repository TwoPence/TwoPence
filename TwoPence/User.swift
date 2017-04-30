//
//  User.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Cely
import Unbox

class User: CelyUser, Unboxable {
    var firstName: String?
    var lastName: String?
    
    var email: String?
    var profileUrl: String?
    var phone: String?
    var savingRates: [Date : Double]?
    
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
        let savingRatesString: [String : Double] = try unboxer.unbox(key: "savingRates")
        for (date, rate) in savingRatesString {
            savingRates?[dateFormatter.date(from: date)!] = rate
        }
        
        self.streetAddr = unboxer.unbox(key: "streetAddr")
        self.cityAddr = unboxer.unbox(key: "cityAddr")
        self.stateAddr = unboxer.unbox(key: "stateAddr")
        self.zipAddr = unboxer.unbox(key: "zipAddr")
        self.countryAddr = unboxer.unbox(key: "countryAddr")
    }
    
    enum Property: CelyProperty {
        case token = "token"
        
        func securely() -> Bool {
            switch self {
            case .token:
                return true
            default:
                return false
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


