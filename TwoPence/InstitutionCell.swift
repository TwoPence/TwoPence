//
//  InstitutionCell.swift
//  TwoPence
//
//  Created by Will Gilman on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class InstitutionCell: UITableViewCell {
    
    @IBOutlet weak var institutionLabel: UILabel!
    
    var institution: Institution! {
        didSet {
            institutionLabel.text = institution.institutionName
        }
    }
    
    override func prepareForReuse() {
        institutionLabel.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
