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
    
    var debtMilestone: DebtMilestone?{
        didSet {
            setupViewData()
            layoutSubviews()
        }
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var joltButton: UIButton!
    @IBOutlet weak var chartView: UIView!
    
    weak var delegate: MilestoneFutureViewDelegate?
    
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
        joltButton.layer.cornerRadius = 4
        
        topView.backgroundColor = AppColor.DarkGreen.color
        joltButton.backgroundColor = AppColor.DarkGreen.color
        addSubview(contentView)
    }
    
    @IBAction func onCloseTap(_ sender: Any) {
        delegate?.didTapCloseButton!()
    }
    
    @IBAction func doJolt(_ sender: Any) {
        delegate?.doJolt!()
    }
    
    func setupViewData(){
        if let milestone = debtMilestone {
            let chart = MilestoneFutureChartView(frame: chartView.bounds)
            self.chartView.addSubview(chart)
            chart.debtMilestone = milestone
        }
    }
}
