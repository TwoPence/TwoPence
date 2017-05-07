//
//  MilestoneFutureView.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/6/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

@objc protocol MilestoneFutureViewDelegate {
    @objc optional func didTapCloseButton()
    @objc optional func doJolt()
}

class MilestoneFutureView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var milestoneFutureImage: UIImageView!
    @IBOutlet weak var milestoneFutureLabel: UILabel!
    @IBOutlet weak var goalProgress: UIProgressView!
    weak var delegate: MilestoneFutureViewDelegate?
    var current: Int = 100

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "MilestoneFutureView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        setMilestoneProgress()
    }
    
    @IBAction func onCloseTap(_ sender: Any) {
        delegate?.didTapCloseButton!()
    }
    
    @IBAction func doJolt(_ sender: Any) {
        delegate?.doJolt!()
    }
    
    func setMilestoneProgress(){
        let transform = CGAffineTransform(scaleX: 1.0, y: 10.0);
        goalProgress.transform = transform;
        
        // Get current values.
        let i = current
        let max = 10
        
        // If we still have progress to make.
        if i <= max {
            // Compute ratio of 0 to 1 for progress.
            let ratio = Float(i) / Float(max)
            // Set progress.
            goalProgress.progress = Float(ratio)
            current += 1
        }
    }
}
