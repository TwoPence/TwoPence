//
//  DebtMilestoneViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Hero

class DebtMilestoneViewController: UIViewController, DebtMilestoneViewDelegate {
    
    @IBOutlet weak var contentView: DebtMilestoneView!
    var selectedMiletone: DebtMilestone?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        contentView.delegate = self
        contentView.heroModifiers = [.fade, .translate(x:0, y:-250)]
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.scrollView.scrollToBottom()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UIBarButtonItem {
            let controller = segue.destination as! ReferralViewController
        } else {
            let controller = segue.destination as! DebtMilestoneDetailViewController
            controller.debtMilestone = selectedMiletone
        }
    }
    
    func navigateToDebtMilestoneDetailViewController(selectedMiletone: DebtMilestone) {
        self.selectedMiletone = selectedMiletone
        if selectedMiletone.type != MilestoneType.Future {
            self.performSegue(withIdentifier: "DebtMilestoneDetailSegue", sender: nil)
        }
    }
}
