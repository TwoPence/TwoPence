//
//  LoginViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TwoPenceAPI.sharedClient.getAggTransactions(success: { (aggTransaction) in
            print(aggTransaction.count)
        }) { (error) in
            print((error.localizedDescription))
        }
        
        TwoPenceAPI.sharedClient.getAccounts(success: { (accounts) in
            print(accounts.count)
        }) { (error) in
            print((error.localizedDescription))
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
