//
//  PendingTransferCell.swift
//  TwoPence
//
//  Created by Will Gilman on 5/5/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class PendingTransferCell: UITableViewCell {
    
    @IBOutlet weak var pendingTransferLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var pendingTransfer: AggTransactions! {
        didSet {
            amountLabel.text = pendingTransfer.amount.money()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = .disclosureIndicator
        pendingTransferLabel.textColor = AppColor.Charcoal.color
        amountLabel.textColor = AppColor.Charcoal.color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        amountLabel.text = nil
    }
    
}
