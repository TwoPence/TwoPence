//
//  MonthCell.swift
//  TwoPence
//
//  Created by Will Gilman on 5/4/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money

class MonthCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    let moneyHandler = NSDecimalNumberHandler(roundingMode: .plain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
    
    var monthlyAggTransactions: MonthlyAggTransactions! {
        didSet {
            monthLabel.text = monthlyAggTransactions.monthAbbrev
            let amount = monthlyAggTransactions.amount.storage.rounding(accordingToBehavior: moneyHandler)
            self.amountLabel.text = "$\(amount)"
        }
    }
    
    override var isSelected: Bool {
        willSet {
            selectedBackgroundView?.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = true
        self.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        self.selectedBackgroundView?.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.1)
        self.selectedBackgroundView?.isHidden = true
    }
    
    override func prepareForReuse() {
        monthLabel.text = nil
        amountLabel.text = nil
    }

}
