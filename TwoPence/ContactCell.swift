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
            if contact.imageDataAvailable {
                if let profileImageData = contact.imageData {
                    profileImageView.image = UIImage(data: profileImageData) ?? UIImage(named: "logo")?.af_imageRoundedIntoCircle()
                    print("custom image")
                }
            } else {
                let profileImage = defaultProfileImage(contact: contact)
                profileImageView.contentMode = .scaleAspectFit
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
    
    func defaultProfileImage(contact: CNContact) -> UIImage? {
        let profileLabel = UILabel()
        profileLabel.frame.size = CGSize(width: 100.0, height: 100.0)
        profileLabel.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
        profileLabel.layer.borderWidth = 2.0
        profileLabel.layer.cornerRadius = 50
        profileLabel.font = UIFont(name: AppFontName.regular, size: 40)
        profileLabel.textColor = AppColor.DarkSeaGreen.color
        profileLabel.adjustsFontSizeToFitWidth = true
        profileLabel.textAlignment = .center
        let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "Two Pence"
        let initials = fullName.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.characters.first!)") + "\($1.characters.first!)" }
        profileLabel.text = initials
        
        UIGraphicsBeginImageContext(profileLabel.frame.size)
        profileLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        let profileImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return profileImage
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
        isContactSelected = false
    }
    
}
