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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransactionsDetailViewController && sender != nil {
            let transactionsDetailViewController = segue.destination as! TransactionsDetailViewController
            transactionsDetailViewController.transactions = sender as! [Transaction]?
        }
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
