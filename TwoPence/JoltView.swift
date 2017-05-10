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
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var totalSavedLabel: UILabel!
    @IBOutlet weak var daysOffLabel: UILabel!
    
    @IBOutlet weak var computedTotalSaved: UILabel!
    @IBOutlet weak var computedDaysSaved: UILabel!
    
    weak var delegate: JoltViewDelegate?
    var computationMetrics: ComputationMetrics?
    var userFinMetrics: UserFinMetrics?
    var joltAmount: Int = 20
    
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
        
        loadComputationMetrics()
        loadUserFinMetrics()
    }
    
    func loadUserFinMetrics() {
        if userFinMetrics == nil {
            TwoPenceAPI.sharedClient.getFinMetrics(success: { (userFinMetrics:UserFinMetrics) in
                self.userFinMetrics = userFinMetrics
                self.setDisplayValues(userFinMetrics: userFinMetrics)
            }) { (error: Error) in
                print(error.localizedDescription)
            }
        } else {
            setDisplayValues(userFinMetrics: userFinMetrics!)
        }
    }
    
    func setDisplayValues(userFinMetrics: UserFinMetrics) {
        self.totalSavedLabel.text = "\(userFinMetrics.totalSaved!)"
        self.daysOffLabel.text = "\(userFinMetrics.daysOffLoanTerm!)"
        self.amountLabel.text = "\(Money(joltAmount))"
    }
    
    func loadComputationMetrics() {
        TwoPenceAPI.sharedClient.getComputationMetrics(success: { (computationMetrics: ComputationMetrics) in
            self.computationMetrics = computationMetrics
            self.updateDisplayValues(amount: Double(self.joltAmount))
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onDecreaseTap(_ sender: UIButton) {
        if (joltAmount - 5) >= 5 {
            joltAmount = joltAmount - 5
            UIView.animate(withDuration: 0.2, animations: {
                self.updateDisplayValues(amount: Double(self.joltAmount))
            })
        }
    }
    
    @IBAction func onIncreaseTap(_ sender: UIButton) {
        joltAmount += 5
        UIView.animate(withDuration: 0.2, animations: {
            self.updateDisplayValues(amount: Double(self.joltAmount))
        })
    }
    
    func updateDisplayValues(amount: Double) {
        amountLabel.text = "\(Money(amount))"
        
        if let computationMetrics = computationMetrics {
            let interestAvoided = ComputationMetrics.interestAvoided(computationMetrics: computationMetrics, payment: amount)
            let totalSavedDelta = interestAvoided + Money(amount)
        
            if let saved = userFinMetrics?.totalSaved {
                let totalSaved = saved.adding(totalSavedDelta)
                computedTotalSaved.text = "\(totalSavedDelta)"
                totalSavedLabel.text = "\(totalSaved)"
            }
        
            let daysSavedDelta = ComputationMetrics.termReductionInDays(computationMetrics: computationMetrics, payment: amount)
        
            if let days = userFinMetrics?.daysOffLoanTerm {
                let daysSaved = days + daysSavedDelta
                computedDaysSaved.text = "+" + String(daysSavedDelta) + " days off"
                daysOffLabel.text = "\(daysSaved)"
            }
        }
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
