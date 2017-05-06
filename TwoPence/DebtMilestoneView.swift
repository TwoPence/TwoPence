//
//  DebtMilestoneView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class DebtMilestoneView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subView: UIView!
    
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
        
        addTimeline()
    }

    func addTimeline(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let timeframe = TimeFrame(text: "The month of love!", date: "February 14", image: #imageLiteral(resourceName: "images"))
        let gest = UITapGestureRecognizer(target: self, action: #selector(self.onTapMilestoneItem(_:)))
        timeline = TimelineView(bulletType: .circle, timeFrames: [timeframe, timeframe, timeframe, timeframe, timeframe, timeframe], onTap: gest)
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
    
    func onTapMilestoneItem(_ sender: UITapGestureRecognizer) {
        print("Hello")
    }
}
