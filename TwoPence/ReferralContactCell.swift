//
//  ReferralContactCell.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/25/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class ReferralContactCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    
    var contact: CNContact! {
        didSet {
            self.contactName.text = contact.givenName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contactName.textColor = AppColor.Charcoal.color
        self.accessoryType = .disclosureIndicator
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
