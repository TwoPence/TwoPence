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
    
    var userProfile: UserProfile? {
        didSet {
            if let profile = userProfile {
                userFullName.text = profile.firstName + " " + profile.lastName
                let gravatar = Gravatar(
                    emailAddress: profile.email,
                    defaultImage: Gravatar.DefaultImage.identicon,
                    forceDefault: false
                )
                profileImageUrl = gravatar.url(size: profileImage.frame.width)
            }
        }
    }
    
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
