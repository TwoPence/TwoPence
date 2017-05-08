//
//  DashboardViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var contentView: DashboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransactionsDetailViewController && sender != nil {
            let transactionsDetailViewController = segue.destination as! TransactionsDetailViewController
            
            // This is a temporary hack to put transactions in the correct format for displayed. This transformation needs to happen elsewhere.
            let transactions = sender as! [Transaction]
            let displayTransactions = transformTransactions(transactions: transactions)
            transactionsDetailViewController.displayTransactions = displayTransactions
        }
    }
    
    // See above comment. This needs to be moved elsewhere.
    func transformTransactions(transactions: [Transaction]) -> [(date: Date, transactions: [Transaction])] {
        var displayTransactions = [(date: Date, transactions: [Transaction])]()
        var dates = [Date]()
        for trans in transactions {
            dates.append(trans.date!)
        }
        let uniqueDates = Set<Date>(dates)
        for date in uniqueDates {
            let trans = transactions.filter({$0.date == date})
            print("\(date), \(trans)")
            displayTransactions.append((date: date, transactions: trans))
        }
        return displayTransactions
    }

}

extension DashboardViewController: DashboardViewDelegate {
    
    func didTapJoltButton(didTap: Bool) {
        if didTap {
            self.performSegue(withIdentifier: "JoltSegue", sender: nil)
        }
    }

    func navigateToTransactionsDetailViewController(selectedTransactions: [Transaction]) {
        self.performSegue(withIdentifier: "TransactionsSegue", sender: selectedTransactions)
    }

}
