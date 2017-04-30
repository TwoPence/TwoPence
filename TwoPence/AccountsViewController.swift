//
//  AccountsViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, AccountsViewDelegate {

    @IBOutlet weak var contentView: AccountsView!
    
    var institution: Institution?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigateToAccountsDetailViewController(selectedInstitution: Institution) {
        institution = selectedInstitution
        self.performSegue(withIdentifier: "AccountDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AccountDetailViewController && institution != nil {
            let accountDetailViewController = segue.destination as! AccountDetailViewController
            accountDetailViewController.institution = institution!
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
