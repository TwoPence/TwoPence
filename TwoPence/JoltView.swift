//
//  JoltView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import PopupDialog

@objc protocol JoltViewDelegate {
    
    @objc optional func didTapCloseButton(didTap: Bool)
}

class JoltView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var computedTotalSaved: UILabel!
    @IBOutlet weak var computedDaysSaved: UILabel!
    
    weak var delegate: JoltViewDelegate?
    
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
    }
    
    @IBAction func onDecreaseTap(_ sender: UIButton) {
        if let amount = amountLabel.text?.trimmingCharacters(in: CharacterSet.symbols) {
            let newAmount = Int(amount)! - 5
            if newAmount >= 0 {
                amountLabel.text = "$" + String(newAmount)
                // Compute here
                computedTotalSaved.text = "+$" + String(newAmount) + " saved"
                computedDaysSaved.text = "+" + String(1) + " days off"
            }
        }
    }
    
    @IBAction func onIncreaseTap(_ sender: UIButton) {
        if let amount = amountLabel.text?.trimmingCharacters(in: CharacterSet.symbols) {
            let newAmount = Int(amount)! + 5
            amountLabel.text = "$" + String(newAmount)
            // Compute here
            computedTotalSaved.text = "+$" + String(newAmount) + " saved"
            computedDaysSaved.text = "+" + String(1) + " days off"
        }
    }
    
    @IBAction func onJoltTap(_ sender: UIButton) {
        if let amount = amountLabel.text?.trimmingCharacters(in: CharacterSet.symbols) {
            let newAmount = Int(amount)!
            if newAmount <= 0 {
                // Show error
                return
            }
        }
        
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
