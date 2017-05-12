//
//  TransactionsDetailViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class TransactionsDetailViewController: UIViewController {

    @IBOutlet weak var contentView: TransactionsView!
    
    var transactions: [Transaction]?
    var groupedTransactions: [(date: Date, transactions: [Transaction])]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if groupedTransactions != nil {
            contentView.groupedTransactions = groupedTransactions!
        }

        updateNavigationBar()
    }
    
    func updateNavigationBar() {
        navigationItem.title = "Transactions"
        if let navigationBar = navigationController?.navigationBar {
            let pageControl = navigationBar.viewWithTag(1) as! UIPageControl
            pageControl.isHidden = true
            navigationBar.barTintColor = UIColor.white
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.black,
                NSFontAttributeName : UIFont(name: "Lato-Regular", size: 17)!
            ]
        }
    }

}
