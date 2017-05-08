//
//  AggTransactionsCell.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class TransferCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var transfer: AggTransactions! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY"
            dateLabel.text = dateFormatter.string(from: transfer.date!)
            amountLabel.text = "\(transfer.amount!)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        amountLabel.text = nil
    }
    
}
