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
        
        automaticallyAdjustsScrollViewInsets = false
        
        if groupedTransactions != nil {
            contentView.groupedTransactions = groupedTransactions!
        }
        updateNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func updateNavigationBar() {
        navigationItem.title = "Transactions"
        self.navigationController?.navigationBar.tintColor = AppColor.Charcoal.color
        if let navigationBar = navigationController?.navigationBar {
            let pageControl = navigationBar.viewWithTag(1) as! UIPageControl
            pageControl.isHidden = true
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : AppColor.Charcoal.color,
                NSFontAttributeName : UIFont(name: AppFontName.regular, size: 17)!
            ]
        }
    }

}
