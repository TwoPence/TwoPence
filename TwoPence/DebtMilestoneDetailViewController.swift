//
//  DebtMilestoneDetailViewController.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/4/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Hero

class DebtMilestoneDetailViewController: UIViewController, MilestoneFutureViewDelegate, MilestoneCompleteViewDelegate {

    @IBOutlet weak var contentView: UIView!
    var debtMilestone: DebtMilestone?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if debtMilestone != nil {
            if (debtMilestone?.type == "completed"){
                let view = MilestoneCompleteView(frame: self.view.frame)
                view.delegate = self
                self.contentView.addSubview(view)
            } else if(debtMilestone?.type == "future"){
                let view = MilestoneFutureView(frame: self.view.frame)
                view.delegate = self
                self.contentView.addSubview(view)
            } else {
                let view = MilestoneCompleteView(frame: self.view.frame)
                view.delegate = self
                self.contentView.addSubview(view)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func doJolt() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "JoltViewController") as! JoltViewController
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func shareMilestone(shareText: String){
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}
