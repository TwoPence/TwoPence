//
//  EmptyTableStateView.swift
//  TwoPence
//
//  Created by Will Gilman on 5/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

protocol EmptyTableStateViewDelegate {
    
    func initiateTransferType(transferType: TransferType)
}

class EmptyTableStateView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var delegate: EmptyTableStateViewDelegate?
    var transferType: TransferType?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "EmptyTableStateView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        setupDisplay()
    }
    
    func setupDisplay() {
        textLabel.font = UIFont(name: AppFontName.regular, size: 15)
        textLabel.textColor = AppColor.MediumGray.color
        actionButton.layer.cornerRadius = 4
        actionButton.backgroundColor = AppColor.DarkSeaGreen.color
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
    }
    
    var emptyStateImage: UIImage? {
        didSet {
            imageView.image = emptyStateImage!
        }
    }
    
    var text: String? {
        didSet {
            textLabel.text = text!
        }
    }
    
    var action: String? {
        didSet {
            actionButton.setTitle(action, for: .normal)
        }
    }
    
    @IBAction func onTapActionButton(_ sender: UIButton) {
        if let type = self.transferType {
            delegate?.initiateTransferType(transferType: type)
        }
    }
}
