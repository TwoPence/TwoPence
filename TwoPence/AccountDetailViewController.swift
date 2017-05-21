//
//  AccountDetailViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController, AccountDetailViewDelegate {

    @IBOutlet weak var contentView: AccountDetailView!
    
    var institution: Institution?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.delegate = self
        // Do any additional setup after loading the view.
        if institution != nil {
            contentView.institution = institution!
        }
    }   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func launchUpdateAccountVC(selectedInstitution: Institution){
        performSegue(withIdentifier: "addUpdateAccountSegue", sender: nil)
    }
    
    func cofirmDeleteAccount(selectedInstitution: Institution){
        let alert = UIAlertController(title: "Confirm?", message: "Are you sure you want to delete \(institution?.name) and \(institution?.accounts.count) accounts associated with it from TwoPence?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: deleteInstitution))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteInstitution(alert: UIAlertAction!){
        // API Call to delete "institution"
        // Show success modal
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
