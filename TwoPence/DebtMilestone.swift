//
//  DebtMilestone.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Unbox

enum MilestoneType: String, UnboxableEnum {
    case Complete
    case Current
    case Future
}

enum GoalType: String, UnboxableEnum {
    case Days
    case Dollars
}

class DebtMilestone: Unboxable {
    var current: Double
    var goal: Double
    var priorGoal: Double
    var goalType: GoalType
    var type: MilestoneType
    var imageName: String //Shold be enum mapped to images?
    var description: String
    var milestoneTitle: String
    var milestoneSubTitle: String
    
    required init(unboxer: Unboxer) throws {
        self.current = try unboxer.unbox(key: "current")
        self.goal = try unboxer.unbox(key: "goal")
        self.priorGoal = try unboxer.unbox(key: "prior_goal")
        self.goalType = try unboxer.unbox(key: "goal_type")
        self.type = try unboxer.unbox(key: "type")
        self.imageName = try unboxer.unbox(key: "image_name")
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
}
