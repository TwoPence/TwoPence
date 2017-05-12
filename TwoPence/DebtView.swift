//
//  DebtView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

protocol DebtViewDelegate {
    
    func didTapJoltButton(didTap: Bool)
}

class DebtView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var withTPProgress: UIProgressView!
    @IBOutlet weak var withoutTPProgress: UIProgressView!
    @IBOutlet weak var withTPLabel: UILabel!
    @IBOutlet weak var withoutTPLabel: UILabel!
    @IBOutlet weak var joltButton: UIButton!
    
    var delegate: DebtViewDelegate?
    
    var userFinMetrics: UserFinMetrics? {
        didSet {
            debtHeaderView.userFinMetrics = userFinMetrics
            setupProgress()
        }
    }
    var debtHeaderView: DebtHeaderView!
    var withTPRatio: Float = 0
    var withoutTPRatio: Float = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "DebtView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        debtHeaderView = DebtHeaderView()
        headerView.addSubview(debtHeaderView)
        contentView.sendSubview(toBack: headerView)
        
        setupJoltButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        debtHeaderView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: headerView.bounds.height)
    }
    
    func setupJoltButton() {
        joltButton.backgroundColor = .clear
        joltButton.layer.cornerRadius = 5
        joltButton.layer.borderWidth = 1
        joltButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        joltButton.layer.borderColor = UIColor.white.cgColor
    }

    func setupProgress() {
        if let daysAtEnrollment = userFinMetrics?.loanTermInDaysAtEnrollment {
            if let daysWithTP = userFinMetrics?.loanTermInDaysWithTp {
                withTPLabel.text = "\(daysWithTP)"
                withTPRatio = Float(daysWithTP) / Float(daysAtEnrollment)
            }
            if let daysWithoutTP = userFinMetrics?.loanTermInDaysWithoutTp {
                withoutTPLabel.text = "\(daysWithoutTP)"
                withoutTPRatio = Float(daysWithoutTP) / Float(daysAtEnrollment)
            }
        }
        
        UIView.animate(withDuration: 2.0, animations: {
            self.withTPProgress.setProgress(self.withTPRatio, animated: true)
            self.withoutTPProgress.setProgress(self.withoutTPRatio, animated: true)
        })
    }
    
    @IBAction func didTapJoltButton(_ sender: UIButton) {
        delegate?.didTapJoltButton(didTap: true)

    }
}
