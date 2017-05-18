//
//  DebtView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

protocol DebtViewDelegate {
    
    func didTapJoltButton(didTap: Bool)
}

class DebtView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var horizontalDividerView: UIView!
    @IBOutlet weak var joltView: UIView!
    @IBOutlet weak var joltMessageLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    
    @IBOutlet weak var withTPLabel: UILabel!
    @IBOutlet weak var withoutTPLabel: UILabel!
    @IBOutlet weak var withTPAmountLabel: UILabel!
    @IBOutlet weak var withoutTPAmountLabel: UILabel!
    
    @IBOutlet weak var withTPBarContainer: UIView!
    @IBOutlet weak var withoutTPBarContainer: UIView!
    @IBOutlet weak var joltButton: UIButton!
    
    var delegate: DebtViewDelegate?
    
    var userFinMetrics: UserFinMetrics? {
        didSet {
            debtHeaderView.userFinMetrics = userFinMetrics
            setupProgressBars()
        }
    }
    var debtHeaderView: DebtHeaderView!
    var withTPProgressBar: CustomProgressBar!
    var withoutTPProgressBar: CustomProgressBar!
    var firstScrolled: Bool = false {
        didSet {
            if firstScrolled {
                fillProgress()
            }
        }
    }
    var withTPRatio: Float = 0
    var withoutTPRatio: Float = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "DebtView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        horizontalDividerView.backgroundColor = AppColor.MediumGreen.color
        joltMessageLabel.textColor = UIColor.white
        footerLabel.textColor = AppColor.MediumGray.color
        withTPLabel.textColor = AppColor.DarkGray.color
        withTPAmountLabel.textColor = AppColor.DarkGray.color
        withoutTPLabel.textColor = AppColor.DarkGray.color
        withoutTPAmountLabel.textColor = AppColor.DarkGray.color
        
        setupJoltButton()
        setupGradientBackgroud()
        
        debtHeaderView = DebtHeaderView()
        headerView.addSubview(debtHeaderView)
        contentView.sendSubview(toBack: headerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        debtHeaderView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: headerView.bounds.height)
    }
    
    func setupGradientBackgroud() {
        let topColor = AppColor.DarkSeaGreen.color.cgColor
        let bottomColor = AppColor.MediumGreen.color.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.2, 1.0]
        let height = headerView.bounds.height + horizontalDividerView.bounds.height + joltView.bounds.height
        let width = headerView.bounds.width
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        gradientLayer.frame = frame
        headerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupJoltButton() {
        joltButton.backgroundColor = AppColor.LightGreen.color
        joltButton.layer.cornerRadius = 5
        joltButton.layer.borderWidth = 1
        joltButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        joltButton.layer.borderColor = UIColor.white.cgColor
    }

    func fillProgress() {
        if let userFinMetrics = userFinMetrics {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 0
            
            let withTPDaysFormatted = numberFormatter.string(from: userFinMetrics.loanTermInDaysWithTp as NSNumber)
            withTPAmountLabel.text = "\(withTPDaysFormatted!) days"
            withTPRatio = Float(userFinMetrics.loanTermInDaysWithTp) / Float(userFinMetrics.loanTermInDaysAtEnrollment)
            
            let withoutTPDaysFormatted = numberFormatter.string(from: userFinMetrics.loanTermInDaysWithoutTp as NSNumber)
            withoutTPAmountLabel.text = "\(withoutTPDaysFormatted!) days"
            withoutTPRatio = Float(userFinMetrics.loanTermInDaysWithoutTp) / Float(userFinMetrics.loanTermInDaysAtEnrollment)
        }
        
        let withInc = Double(withTPRatio) * Double(withTPBarContainer.bounds.width)
        withTPProgressBar.progress(incremented: CGFloat(withInc))
        
        let withoutInc = Double(withoutTPRatio) * Double(withoutTPBarContainer.bounds.width)
        withoutTPProgressBar.progress(incremented: CGFloat(withoutInc))
    }
    
    
    func setupProgressBars() {
        withTPProgressBar = CustomProgressBar(width: withTPBarContainer.bounds.width, height: withTPBarContainer.bounds.height)
        withTPBarContainer.addSubview(withTPProgressBar)
        withTPProgressBar.configure()
        
        withoutTPProgressBar = CustomProgressBar(width: withoutTPBarContainer.bounds.width, height: withoutTPBarContainer.bounds.height)
        withoutTPBarContainer.addSubview(withoutTPProgressBar)
        withoutTPProgressBar.configure()
    }
    
    @IBAction func didTapJoltButton(_ sender: UIButton) {
        delegate?.didTapJoltButton(didTap: true)

    }
}
