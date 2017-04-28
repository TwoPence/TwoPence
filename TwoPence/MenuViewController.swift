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
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController")
        let debtMilestoneViewController = storyboard.instantiateViewController(withIdentifier: "DebtMilestoneViewController")
        let transactionsNavigationController = storyboard.instantiateViewController(withIdentifier: "TransactionsNavigationController")
        let accountsNavigationController = storyboard.instantiateViewController(withIdentifier: "AccountsNavigationController")
        let settingsNavigationController = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationController")
        let faqViewController = storyboard.instantiateViewController(withIdentifier: "FAQViewController")
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        
        menuView.delegate = self
        menuView.viewControllers = [
            ("Dashboard", dashboardViewController),
            ("Debt Milestones", debtMilestoneViewController),
            ("Transactions", transactionsNavigationController),
            ("Accounts", accountsNavigationController),
            ("Settings", settingsNavigationController),
            ("FAQ", faqViewController),
            ("Logout", loginViewController)
        ]
        menuView.tableView.reloadData()
        
        activeViewController = dashboardViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passActiveViewController(viewController: UIViewController) {
        activeViewController = viewController
    }
    
    private func updateActiveViewController() {
        if isViewLoaded {
            if let activeVC = activeViewController {
                addChildViewController(activeVC)
                activeVC.view.frame = contentView.containerView.bounds
                contentView.containerView.addSubview(activeVC.view)
                activeVC.didMove(toParentViewController: self)
            }
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if isViewLoaded {
            if let inactiveVC = inactiveViewController {
                inactiveVC.willMove(toParentViewController: nil)
                inactiveVC.view.removeFromSuperview()
                inactiveVC.removeFromParentViewController()
            }
        }
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
