//
//  TransactionCell.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import SwipeCellKit

class TransactionCell: SwipeTableViewCell {
    
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountSavedLabel: UILabel!
    
    var transaction: Transaction! {
        didSet {
            merchantLabel.text = transaction.merchant
            amountLabel.text = "\(transaction.amount) spent"
            amountSavedLabel.text = "\(transaction.amountSaved)"
            if transaction.status == .Skipped {
                merchantLabel.textColor = AppColor.MediumGray.color
                amountLabel.textColor = AppColor.MediumGray.color
                amountSavedLabel.textColor = AppColor.MediumGray.color
            } else {
                merchantLabel.textColor = AppColor.Charcoal.color
                amountLabel.textColor = AppColor.Charcoal.color
                amountSavedLabel.textColor = AppColor.Charcoal.color
            }
        }
    }
    
    override func prepareForReuse() {
        merchantLabel.text = nil
        amountLabel.text = nil
        amountSavedLabel.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        merchantLabel.textColor = AppColor.Charcoal.color
        amountLabel.textColor = AppColor.Charcoal.color
        amountSavedLabel.textColor = AppColor.Charcoal.color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
