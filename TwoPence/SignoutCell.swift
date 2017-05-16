//
//  SettingsCell.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/10/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class SignoutCell: UITableViewCell {
    
    
    @IBOutlet weak var signoutName: UILabel!
    
    override func prepareForReuse() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.signoutName.textColor = AppColor.Red.color
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
