//
//  AccountCell.swift
//  TwoPence
//
//  Created by Will Gilman on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var account: Account! {
        didSet {
            accountLabel.text = account.name
            amountLabel.text = account.value.money()
        }
    }
    
    override func prepareForReuse() {
        accountLabel.text = nil
        amountLabel.text = nil
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
