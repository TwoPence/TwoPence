//
//  DebtMilestone.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Unbox
import Money

enum MilestoneType: Int, UnboxableEnum {
    case Complete
    case Current
    case Future
}

class DebtMilestone: Unboxable {
    var current: Money
    var goal: Money
    
    var type: MilestoneType
    var imageName: String //Shold be enum mapped to images?
    var description: String
    var milestoneTitle: String
    var milestoneSubTitle: String
    
    required init(unboxer: Unboxer) throws {
        let currentDouble: Double = try unboxer.unbox(key: "current")
        self.current = Money(currentDouble)
        
        let goalDouble: Double = try unboxer.unbox(key: "goal")
        self.goal = Money(goalDouble)
        
        self.type = try unboxer.unbox(key: "type")
        self.imageName = try unboxer.unbox(key: "imageName")
        self.description = try unboxer.unbox(key: "description")
        self.milestoneTitle = try unboxer.unbox(key: "milestone_title")
        self.milestoneSubTitle = try unboxer.unbox(key: "milestone_sub_title")
    }
    
    
    class func  withArray(dictionaries: [Dictionary<String, Any>]) throws -> [DebtMilestone] {
        var milestones = [DebtMilestone]()
        
        for dict in dictionaries {
            let milestone: DebtMilestone = try unbox(dictionary: dict)
            milestones.append(milestone)
        }
        
        return milestones
    }
    
    // For testing only
    init(type: MilestoneType) {
        self.current = Money(10.0)
        self.goal = Money(200.0)
        self.type = type
        self.imageName = "completed"
        self.description = "Testing my description"
        
        if type == MilestoneType.Complete {
            self.milestoneTitle = "Congratulations!"
            self.milestoneSubTitle = "Milestone completed!"
        } else if type == MilestoneType.Current {
            self.milestoneTitle = "Next Milestone!"
            self.milestoneSubTitle = "Jolt to reach your milestone sooner!"
        } else {
            self.milestoneTitle = "Upcoming Milestone!"
            self.milestoneSubTitle = "View this on completing previous milestone"
        }
    }
}
