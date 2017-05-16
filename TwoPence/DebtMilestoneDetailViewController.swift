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
    
    var completeView: MilestoneCompleteView?
    var futureView: MilestoneFutureView?
    var confettiView: SAConfettiView?
    var debtMilestone: DebtMilestone?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if debtMilestone != nil {
            if (debtMilestone?.type == MilestoneType.Complete){
                confettiView = SAConfettiView(frame: self.view.bounds)
                confettiView?.isUserInteractionEnabled = false
                completeView = MilestoneCompleteView(frame: self.view.frame)
                completeView?.delegate = self
                
                self.contentView.addSubview(completeView!)
                self.contentView.addSubview(confettiView!)
                confettiView?.startConfetti()
            } else if(debtMilestone?.type == MilestoneType.Current){
                futureView = MilestoneFutureView(frame: self.view.frame)
                futureView?.delegate = self
                
                self.contentView.addSubview(futureView!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if completeView != nil {
            completeView?.debtMilestone = debtMilestone
        } else if futureView != nil {
            futureView?.debtMilestone = debtMilestone
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        futureView?.animateProgressBar = true
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
        self.confettiView?.stopConfetti()
        dismiss(animated: true, completion: nil)
    }
    
    func doJolt() {
        self.performSegue(withIdentifier: "JoltSegue", sender: nil)
    }
    
    func shareMilestone(shareText: String){
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}
