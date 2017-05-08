//
//  DebtView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class DebtView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loanRepaidLabel: UILabel!
    @IBOutlet weak var interestAvoidedLabel: UILabel!
    @IBOutlet weak var daysOffLoanTermLabel: UILabel!
    @IBOutlet weak var withTPProgress: UIProgressView!
    @IBOutlet weak var withoutTPProgress: UIProgressView!
    @IBOutlet weak var withTPLabel: UILabel!
    @IBOutlet weak var withoutTPLabel: UILabel!
    
    var userFinMetrics: UserFinMetrics!
    
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
        
        setFinMetrics()
    }
    
    func setFinMetrics() {
        TwoPenceAPI.sharedClient.getFinMetrics(success: { (userFinMetrics: UserFinMetrics) in
            self.userFinMetrics = userFinMetrics
            self.setupHeaderView()
            self.setupProgressBars()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func setupHeaderView() {
        loanRepaidLabel.text = "\(userFinMetrics.loanRepaid!)"
        interestAvoidedLabel.text = "\(userFinMetrics.interestAvoided!)"
        daysOffLoanTermLabel.text = "\(userFinMetrics.daysOffLoanTerm!)"
        withTPLabel.text = "\(userFinMetrics.loanTermInDaysWithTp!)"
        withoutTPLabel.text = "\(userFinMetrics.loanTermInDaysWithoutTp!)"
    }

    func setupProgressBars() {
        let daysAtEnrollment = userFinMetrics.loanTermInDaysAtEnrollment!
        let daysWithTP = userFinMetrics.loanTermInDaysWithTp!
        let daysWithoutTP = userFinMetrics.loanTermInDaysWithoutTp!
        let withTPRatio = Float(daysWithTP) / Float(daysAtEnrollment)
        let withoutTPRatio = Float(daysWithoutTP) / Float(daysAtEnrollment)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.withTPProgress.setProgress(withTPRatio, animated: true)
            self.withoutTPProgress.setProgress(withoutTPRatio, animated: true)
        })
    }

}
