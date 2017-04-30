//
//  TransactionsViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController, AggTransactionsViewDelegate {

    @IBOutlet weak var contentView: AggTransactionsView!
    
    var transactions: [Transaction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigateToTransactionsDetailViewController(selectedTransactions: [Transaction]) {
        transactions = selectedTransactions
        self.performSegue(withIdentifier: "TransactionsDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransactionsDetailViewController && transactions != nil {
            let transactionsDetailViewController = segue.destination as! TransactionsDetailViewController
            transactionsDetailViewController.transactions = transactions!
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
