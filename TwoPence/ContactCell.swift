//
//  ContactCell.swift
//  TwoPence
//
//  Created by Will Gilman on 5/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class ContactCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    var contact: CNContact! {
        didSet {
            nameLabel.text = CNContactFormatter.string(from: contact, style: .fullName)
            emailLabel.text = contact.emailAddresses.first?.value as String?
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.clipsToBounds = true
            if contact.imageDataAvailable {
                let profileImage = UIImage(data: contact.thumbnailImageData!)
                profileImageView.image = profileImage?.af_imageRoundedIntoCircle()
                profileImageView.layer.borderWidth = 1.0
                profileImageView.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
                profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
            } else {
                let profileImage = Utils.profileImageFromContact(contact: contact)
                profileImageView.image = profileImage
            }
        }
    }
    var isContactSelected: Bool! {
        didSet {
            if isContactSelected {
                selectedButton.tag = 1
                selectedButton.backgroundColor = AppColor.DarkSeaGreen.color
            } else {
                selectedButton.tag = 0
                selectedButton.backgroundColor = UIColor.clear
            }
        }
    }
    
    func disableButton() {
        selectedButton.isHidden = true
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = UIFont(name: AppFontName.regular, size: 17)
        nameLabel.textColor = AppColor.Charcoal.color
        emailLabel.font = UIFont(name: AppFontName.regular, size: 13)
        emailLabel.textColor = AppColor.MediumGray.color
        selectedButton.tag = 0
        selectedButton.layer.cornerRadius = 0.5 * selectedButton.bounds.size.width
        selectedButton.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
        selectedButton.layer.borderWidth = 1
        selectedButton.clipsToBounds = true
        selectedButton.isHidden = false
        selectedButton.isUserInteractionEnabled = false
        isContactSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        emailLabel.text = nil
        profileImageView.image = nil
        profileImageView.layer.borderWidth = 0.0
        isContactSelected = false
    }
    
}
