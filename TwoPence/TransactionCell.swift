//
//  TransactionCell.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountSavedLabel: UILabel!
    
    var transaction: Transaction! {
        didSet {
            merchantLabel.text = transaction.merchant
            amountLabel.text = "\(transaction.amount!)"
            amountSavedLabel.text = "\(transaction.amountSaved!)"
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
