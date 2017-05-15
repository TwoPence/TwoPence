//
//  ProfileCell.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/11/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    
    var profileImageUrl: URL? {
        didSet {
            self.profileImage.af_setImage(withURL: profileImageUrl!,
                                          filter: CircleFilter(),
                                          imageTransition: .flipFromBottom(0.5))
        }
    }
    
    override func prepareForReuse() {
        profileImage.image = nil
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
