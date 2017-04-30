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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if transactions != nil {
            contentView.transactions = transactions!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
