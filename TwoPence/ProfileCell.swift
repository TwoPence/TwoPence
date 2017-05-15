//
//  ProfileCell.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/11/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    
    override func prepareForReuse() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userFullName.textColor = AppColor.Charcoal.color
        self.isUserInteractionEnabled = false
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
