//
//  ContentViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MenuViewDelegate {
    
    @IBOutlet weak var contentView: ContentView!
    @IBOutlet weak var menuView: MenuView!
    
    weak var delegate: MenuViewDelegate?
    
    private var activeViewController: UIViewController? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController")
        let debtMilestoneViewController = storyboard.instantiateViewController(withIdentifier: "DebtMilestoneViewController")
        let transactionsNavigationController = storyboard.instantiateViewController(withIdentifier: "TransactionsNavigationController")
        let accountsNavigationController = storyboard.instantiateViewController(withIdentifier: "AccountsNavigationController")
        let settingsNavigationController = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationController")
        let faqViewController = storyboard.instantiateViewController(withIdentifier: "FAQViewController")
        
        menuView.viewControllers = [
            ("Dashboard", dashboardViewController),
            ("Debt Milestones", debtMilestoneViewController),
            ("Transactions", transactionsNavigationController),
            ("Accounts", accountsNavigationController),
            ("Settings", settingsNavigationController),
            ("FAQ", faqViewController)
        ]
        menuView.tableView.reloadData()
        
        activeViewController = dashboardViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passActiveViewController(activeViewController: UIViewController) {
        activeViewController = activeViewController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
