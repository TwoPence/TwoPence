//
//  JoltCell.swift
//  TwoPence
//
//  Created by Will Gilman on 5/14/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class JoltCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var jolt: AggTransactions! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY"
            dateLabel.text = dateFormatter.string(from: jolt.date)
            amountLabel.text = jolt.amount.money()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateLabel.textColor = AppColor.Charcoal.color
        amountLabel.textColor = AppColor.Charcoal.color
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