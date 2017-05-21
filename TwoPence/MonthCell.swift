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
            monthLabel.text = monthlyAggTransactions.monthAbbrev
            self.amountLabel.text = monthlyAggTransactions.amount.money(round: true)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            selectedBackgroundView?.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isUserInteractionEnabled = true
        selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        selectedBackgroundView?.backgroundColor = UIColor(red: 66/255, green: 181/255, blue: 128/255, alpha: 1.0)
        let selectedBar = UIView(frame: CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1))
        selectedBar.backgroundColor = UIColor.white
        selectedBackgroundView?.addSubview(selectedBar)
        selectedBackgroundView?.isHidden = true
    }
    
    override func prepareForReuse() {
        monthLabel.text = nil
        amountLabel.text = nil
    }

}
