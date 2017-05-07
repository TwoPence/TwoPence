//
//  DebtMilestone.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Unbox

class DebtMilestone: Unboxable {
    var value: String?
    var type: String? //Should be enum?
    var imageName: String? //Shold be enum mapped to images?
    var description: String?
    
    required init(unboxer: Unboxer) throws {
        self.value = unboxer.unbox(key: "value")
        self.type = unboxer.unbox(key: "type")
        self.imageName = unboxer.unbox(key: "imageName")
        self.description = unboxer.unbox(key: "description")
    }
    
    
    class func  withArray(dictionaries: [Dictionary<String, Any>]) throws -> [DebtMilestone] {
        var milestones = [DebtMilestone]()
        
        for dict in dictionaries {
            let milestone: DebtMilestone = try unbox(dictionary: dict)
            milestones.append(milestone)
        }
        
        return milestones
    }
    
    init() {
        self.value = "$100"
        self.type = "completed"
        self.imageName = "completed"
        self.description = "Testing my description"
    }
}
