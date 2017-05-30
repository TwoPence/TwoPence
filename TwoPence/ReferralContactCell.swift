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
    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var contact: CNContact! {
        didSet {
            self.contactName.text = contact.givenName
            self.contactEmail.text = contact.emailAddresses.first?.value as String?
            if contact.imageDataAvailable {
                self.profilePicture.image = UIImage(data: contact.imageData!)?.af_imageRoundedIntoCircle()
            } else {
                self.profilePicture.image = UIImage(named: "logo")?.af_imageRoundedIntoCircle()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contactName.textColor = AppColor.Charcoal.color
        self.contactEmail.textColor = AppColor.MediumGray.color
        //self.accessoryType = .disclosureIndicator
        
        selectedButton.tag = 0
        selectedButton.layer.cornerRadius = 0.5 * selectedButton.bounds.size.width
        selectedButton.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
        selectedButton.layer.borderWidth = 1
        selectedButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
