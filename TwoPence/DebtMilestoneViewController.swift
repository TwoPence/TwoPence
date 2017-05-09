//
//  DebtMilestoneViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Hero
import Whisper

class DebtMilestoneViewController: UIViewController, DebtMilestoneViewDelegate {
    
    @IBOutlet weak var contentView: DebtMilestoneView!
    var selectedMiletone: DebtMilestone?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove me
        let message = Message(title: "This is a test message", backgroundColor: .red)
        Whisper.show(whisper: message, to: self.navigationController!, action: .show)
        
        contentView.delegate = self
        contentView.heroModifiers = [.fade, .translate(x:0, y:-250)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DebtMilestoneDetailViewController
        controller.debtMilestone = selectedMiletone
    }
    
    func navigateToDebtMilestoneDetailViewController(selectedMiletone: DebtMilestone) {
        self.selectedMiletone = selectedMiletone
        if selectedMiletone.type != MilestoneType.Future {
            self.performSegue(withIdentifier: "DebtMilestoneDetailSegue", sender: nil)
        }
    }
}
