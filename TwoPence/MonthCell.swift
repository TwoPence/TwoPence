//
//  MonthCell.swift
//  TwoPence
//
//  Created by Will Gilman on 5/4/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class MonthCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var monthlyAggTransactions: MonthlyAggTransactions! {
        didSet {
            self.monthLabel.text = monthlyAggTransactions.monthAbbrev!
            self.amountLabel.text = "\(monthlyAggTransactions.amount!)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor(red: 243/255, green: 232/255, blue: 143/255, alpha: 1.0)
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    override func prepareForReuse() {
        monthLabel.text = nil
        amountLabel.text = nil
    }

}
