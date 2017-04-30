//
//  AggTransactionsCell.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class AggTransactionsCell: UITableViewCell {

    @IBOutlet weak var aggTransactionsLabel: UILabel!
    
    var aggTransactions: AggTransactions! {
        didSet {
            aggTransactionsLabel.text = "\(aggTransactions.amount) transfered on \(aggTransactions.date)"
        }
    }
    
    override func prepareForReuse() {
        aggTransactionsLabel.text = nil
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
