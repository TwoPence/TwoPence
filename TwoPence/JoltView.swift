//
//  JoltView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money
import PopupDialog

@objc protocol JoltViewDelegate {
    
    @objc optional func didTapCloseButton(didTap: Bool)
}

class JoltView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    weak var delegate: JoltViewDelegate?
    
    var computationMetrics: ComputationMetrics?
    var userFinMetrics: UserFinMetrics? {
        didSet {
            debtHeaderView.userFinMetrics = userFinMetrics
        }
    }
    var debtHeaderView: DebtHeaderView!
    var joltAmount: Int = 20 {
        didSet {
            amountLabel.text = "\(Money(joltAmount))"
            updateDisplay(amount: Double(joltAmount))
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "JoltView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        debtHeaderView = DebtHeaderView()
        headerView.addSubview(debtHeaderView)
        contentView.sendSubview(toBack: headerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        debtHeaderView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: headerView.bounds.height)
    }
    
    @IBAction func onDecreaseTap(_ sender: UIButton) {
        if (joltAmount - 5) >= 5 {
            joltAmount = joltAmount - 5
        }
    }
    
    @IBAction func onIncreaseTap(_ sender: UIButton) {
        joltAmount += 5
    }
    
    func updateDisplay(amount: Double) {
        UIView.animate(withDuration: 0.15, animations: {
            if let computationMetrics = self.computationMetrics {
                self.debtHeaderView.loanRepaidDelta = Money(amount)
            
                let interestAvoided = ComputationMetrics.interestAvoided(computationMetrics: computationMetrics, payment: amount)
                self.debtHeaderView.interestAvoidedDelta = interestAvoided
        
                let daysOffDelta = ComputationMetrics.termReductionInDays(computationMetrics: computationMetrics, payment: amount)
                self.debtHeaderView.daysOffDelta = daysOffDelta
            }
        })
    }
    
    @IBAction func onJoltTap(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 120)
        let customView = UIView(frame: rect)
        
        let label = UILabel(frame: CGRect(x: customView.center.x, y: customView.center.y, width: customView.frame.width, height: customView.frame.height/3))
        label.text = "TwoPence will debit \(amountLabel.text ?? "$0") from your bank account."
        label.center = customView.center
        label.center.x = customView.center.x
        label.center.y = customView.center.y
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        customView.addSubview(label)
        alertController.view.addSubview(customView)
        
        let somethingAction = UIAlertAction(title: "Confirm", style: .default, handler: {(alert: UIAlertAction!) in self.showSuccessView()})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        topVC?.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onCloseTap(_ sender: UIButton) {
        delegate?.didTapCloseButton?(didTap: true)
    }
    
    func showSuccessView(){
        
        let title = "Congratulations!"
        let message = "You have successfully added \(amountLabel.text ?? "$0")!"
        let image = #imageLiteral(resourceName: "images") //Some nice GIF here
        
        let popup = PopupDialog(title: title, message: message, image: image, gestureDismissal: false)
        
        let buttonOne = DefaultButton(title: "Done") {
            self.delegate?.didTapCloseButton?(didTap: true) // Replace this with image like X?
        }

        popup.addButton(buttonOne)
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        
        topVC?.present(popup, animated: true, completion: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
