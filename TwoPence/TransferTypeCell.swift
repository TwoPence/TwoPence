//
//  TransferTypeCell.swift
//  TwoPence
//
//  Created by Will Gilman on 5/31/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class TransferTypeCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var typeTotal: (type: TransferType, total: Double)! {
        didSet {
            typeLabel.text = typeTotal.type.label
            amountLabel.text = typeTotal.total.money(round: true)
            colorView.backgroundColor = typeTotal.type.color
            iconImageView.image = typeTotal.type.icon
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = .disclosureIndicator
        self.typeLabel.textColor = AppColor.Charcoal.color
        self.typeLabel.font = UIFont(name: AppFontName.regular, size: 17)
        self.amountLabel.textColor = AppColor.Charcoal.color
        self.amountLabel.font = UIFont(name: AppFontName.regular, size: 17)
    }

    
}
