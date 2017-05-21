//
//  DebtView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import EFCountingLabel

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
    @IBOutlet weak var withTPAmountLabel: EFCountingLabel!
    @IBOutlet weak var withoutTPAmountLabel: EFCountingLabel!
    
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
    var withTPAmount: Int = 0
    var withoutTPAmount: Int = 0
    var withTPRatio: Float = 0
    var withoutTPRatio: Float = 0
    let withDuration: CFTimeInterval = 1.0
    
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
        
        setupDisplay()
        setupGradientBackground()
        setupJoltButton()
        
        debtHeaderView = DebtHeaderView()
        headerView.addSubview(debtHeaderView)
        contentView.sendSubview(toBack: headerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        debtHeaderView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: headerView.bounds.height)
    }
    
    func setupDisplay() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        horizontalDividerView.backgroundColor = AppColor.MediumGreen.color
        joltMessageLabel.textColor = UIColor.white
        footerLabel.textColor = AppColor.MediumGray.color
        withTPLabel.textColor = AppColor.DarkGray.color
        withTPAmountLabel.textColor = AppColor.DarkGray.color
        withTPAmountLabel.formatBlock = {
            (value) in
            return numberFormatter.string(from: NSNumber(value: Int(value))) ?? "n/a"
        }
        withoutTPLabel.textColor = AppColor.DarkGray.color
        withoutTPAmountLabel.textColor = AppColor.DarkGray.color
        withoutTPAmountLabel.formatBlock = {
            (value) in
            return numberFormatter.string(from: NSNumber(value: Int(value))) ?? "n/a"
        }
    }
    
    func setupGradientBackground() {
        let height = headerView.bounds.height + horizontalDividerView.bounds.height + joltView.bounds.height
        let width = headerView.bounds.width
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        Utils.setupGradientBackground(topColor: AppColor.DarkSeaGreen.color.cgColor, bottomColor: AppColor.MediumGreen.color.cgColor, view: headerView, frame: frame)
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
            // Only perform the counting once.
            if withTPAmount == 0 {
                withTPAmountLabel.countFromZeroTo(CGFloat(userFinMetrics.loanTermInDaysWithTp), withDuration: withDuration)
                withTPAmount = userFinMetrics.loanTermInDaysWithTp
            }
            withTPRatio = Float(userFinMetrics.loanTermInDaysWithTp) / Float(userFinMetrics.loanTermInDaysAtEnrollment)
            
            if withoutTPAmount == 0 {
                withoutTPAmountLabel.countFromZeroTo(CGFloat(userFinMetrics.loanTermInDaysWithoutTp), withDuration: withDuration)
                withoutTPAmount = userFinMetrics.loanTermInDaysWithoutTp
            }
            withoutTPRatio = Float(userFinMetrics.loanTermInDaysWithoutTp) / Float(userFinMetrics.loanTermInDaysAtEnrollment)
        }
        
        let withInc = Double(withTPRatio) * Double(withTPBarContainer.bounds.width)
        withTPProgressBar.progress(incremented: CGFloat(withInc), withDuration: withDuration)
        
        let withoutInc = Double(withoutTPRatio) * Double(withoutTPBarContainer.bounds.width)
        withoutTPProgressBar.progress(incremented: CGFloat(withoutInc), withDuration: withDuration)
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
