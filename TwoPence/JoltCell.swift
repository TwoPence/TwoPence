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
    
    var jolt: Transfer! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            dateLabel.text = dateFormatter.string(from: jolt.date) + jolt.date.daySuffix()
            amountLabel.text = jolt.amount.money()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateLabel.textColor = AppColor.Charcoal.color
        dateLabel.font = UIFont(name: AppFontName.regular, size: 17)
        amountLabel.textColor = AppColor.Charcoal.color
        amountLabel.font = UIFont(name: AppFontName.regular, size: 17)
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
