//
//  DebtMilestoneView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

protocol DebtMilestoneViewDelegate {
    
    func navigateToDebtMilestoneDetailViewController(selectedMiletone: DebtMilestone)
}

class DebtMilestoneView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var milestones: [DebtMilestone]?
    var delegate: DebtMilestoneViewDelegate?
    var timeline: TimelineView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "DebtMilestoneView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        self.milestones = [DebtMilestone]()
        self.milestones?.append(DebtMilestone(type: MilestoneType.Complete))
        self.milestones?.append(DebtMilestone(type: MilestoneType.Complete))
        self.milestones?.append(DebtMilestone(type: MilestoneType.Complete))
        self.milestones?.append(DebtMilestone(type: MilestoneType.Current))
        self.milestones?.append(DebtMilestone(type: MilestoneType.Future))
        
        addTimeline()
    }

    func addTimeline(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        var timeframes = [TimeFrame]()
        for (index, milestone) in milestones!.enumerated() {
            timeframes.append(TimeFrame(text: "", date: "", debtMilestone: milestone, debtMilestonePosition: index, image: #imageLiteral(resourceName: "images")))
        }
        
        timeline = TimelineView(bulletType: .circle, timeFrames: timeframes, onTap: onTapMilestoneItem)
        timeline.isUserInteractionEnabled = true
        scrollView.addSubview(timeline)
        scrollView.isUserInteractionEnabled = true
        
        scrollView.addConstraints([
            NSLayoutConstraint(item: timeline, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .right, multiplier: 1.0, constant: 0),
            
            NSLayoutConstraint(item: timeline, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0)
            ])
    }
    
    func onTapMilestoneItem(_ sender: AnyObject, event: UIEvent) {
        let debtMilestone = self.milestones?[sender.tag]
        delegate?.navigateToDebtMilestoneDetailViewController(selectedMiletone: debtMilestone!)
    }
}
