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
    var withTPDays: Int = 0
    var withoutTPDays: Int = 0
    
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
        let jolt = #imageLiteral(resourceName: "lightningboltcream")
        let joltResized = jolt.af_imageAspectScaled(toFit: CGSize(width: 10, height: 20))
        joltButton.tintColor = AppColor.Cream.color
        joltButton.setImage(joltResized, for: .normal)
        joltButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 40, bottom: 5, right: 5)
        joltButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 15)
        joltButton.backgroundColor = AppColor.LightGreen.color
        joltButton.layer.cornerRadius = 5
        joltButton.layer.borderWidth = 1
        joltButton.layer.borderColor = UIColor.white.cgColor
        joltButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 15)
        joltButton.titleLabel?.textColor = UIColor.white
    }

    func fillProgress() {
        if let userFinMetrics = userFinMetrics {
            
            if isFirstScroll() {
                withTPDays = userFinMetrics.loanTermInDaysWithTp
                withoutTPDays = userFinMetrics.loanTermInDaysWithoutTp
                let daysAtEnrollment = userFinMetrics.loanTermInDaysAtEnrollment
                let withTPRatio = 1.0 - Float(withTPDays) / Float(daysAtEnrollment)
                let withoutTPRatio = 1.0 - Float(withoutTPDays) / Float(daysAtEnrollment)
                let withFillDuration = 1.5
                let withoutFillDuration = CFTimeInterval(Float(withFillDuration) / (withTPRatio / withoutTPRatio))
                
                let withProgress = Double(withTPRatio) * Double(withTPBarContainer.bounds.width)
                let withoutProgress = Double(withoutTPRatio) * Double(withoutTPBarContainer.bounds.width)
                
                withTPAmountLabel.countFrom(CGFloat(daysAtEnrollment), to: CGFloat(withTPDays), withDuration: withFillDuration)
                withoutTPAmountLabel.countFrom(CGFloat(daysAtEnrollment), to: CGFloat(withoutTPDays), withDuration: withoutFillDuration)
            
                withTPProgressBar.progress(incremented: CGFloat(withProgress), withDuration: withFillDuration)
                withoutTPProgressBar.progress(incremented: CGFloat(withoutProgress), withDuration: withoutFillDuration)
        
                let fillDurationDiff = CFTimeInterval(Float(withFillDuration) - Float(withoutFillDuration))
                let timeRecovered = userFinMetrics.daysOffLoanTerm.toLCD()
                debtHeaderView.setTimeDisplay(timeRecovered: timeRecovered, withDuration: fillDurationDiff, withDelay: withoutFillDuration)
            }
        }
    }
    
    func isFirstScroll() -> Bool {
        return (withTPDays == 0 && withoutTPDays == 0)
    }
    
    func setupProgressBars() {
        withTPProgressBar = CustomProgressBar(width: withTPBarContainer.bounds.width, height: withTPBarContainer.bounds.height, color: nil, progressColor: nil, cornerRadius: nil, fillDirection: .left)
        withTPBarContainer.addSubview(withTPProgressBar)
        withTPProgressBar.configure()
        
        withoutTPProgressBar = CustomProgressBar(width: withoutTPBarContainer.bounds.width, height: withoutTPBarContainer.bounds.height, color: nil, progressColor: AppColor.PaleGreen.color.cgColor, cornerRadius: nil, fillDirection: .left)
        withoutTPBarContainer.addSubview(withoutTPProgressBar)
        withoutTPProgressBar.configure()
    }
    
    @IBAction func didTapJoltButton(_ sender: UIButton) {
        delegate?.didTapJoltButton(didTap: true)
    }
}
