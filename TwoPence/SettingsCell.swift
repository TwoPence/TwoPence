//
//  SettingsCell.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/10/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var settingOptionName: UILabel!
    
    override func prepareForReuse() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingOptionName.textColor = AppColor.Charcoal.color
        self.accessoryType = .disclosureIndicator
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
