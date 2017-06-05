//
//  SponsorCell.swift
//  TwoPence
//
//  Created by Will Gilman on 5/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class SponsorCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalMatchedAmountLabel: UILabel!
    
    var sponsor: Sponsor! {
        didSet {
            nameLabel.text = sponsor.name
            totalMatchedAmountLabel.text = sponsor.totalMatchedAmount.money(round: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        nameLabel.font = UIFont(name: AppFontName.regular, size: 17)
        nameLabel.textColor = AppColor.Charcoal.color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
