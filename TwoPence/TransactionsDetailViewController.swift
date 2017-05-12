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
        
        updateNavigationBar(hidePageControl: true, navigationBarTitle: "Transactions", backButtonTitle: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateNavigationBar(hidePageControl: false, navigationBarTitle: "", backButtonTitle: "Savings")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNavigationBar(hidePageControl: Bool, navigationBarTitle: String, backButtonTitle: String) {
        self.navigationItem.title = navigationBarTitle
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        if let navigationBar = navigationController?.navigationBar {
            let pageControl = navigationBar.viewWithTag(1)
            pageControl?.isHidden = hidePageControl
            navigationBar.topItem?.title = backButtonTitle
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
