//
//  SettingsViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    //var gravatar: Gravatar?
    
    let menuOptions = [
        [["name":"Profile"]],
        [["name":"Accounts"]],
        [["name":"Settings"], ["name":"Linked User"],  ["name": "FAQ"], ["name":"Invite a friend"]],
        [["name" : "Sign out"]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        tableView.register(UINib(nibName: "SignoutCell", bundle: nil), forCellReuseIdentifier: "SignoutCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 45
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return menuOptions[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.userFullName.text = "Utkarsh Sengar"
            // Pull gravatar
            let gravatar = Gravatar(
                emailAddress: "utkarsh2012@gmail.com",
                defaultImage: Gravatar.DefaultImage.identicon,
                forceDefault: false
            )
            cell.profileImageUrl = gravatar.url(size: cell.profileImage.frame.width)
            return cell
        } else if indexPath.section == 1 || indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
            cell.settingOptionName.text = menuOptions[indexPath.section][indexPath.row]["name"]
            if indexPath.section == 1 {
                cell.imageView?.image = #imageLiteral(resourceName: "accounts")
            } else {
                if indexPath.row == 0 {
                    cell.imageView?.image = #imageLiteral(resourceName: "shape")
                } else if indexPath.row == 1 {
                    cell.imageView?.image = #imageLiteral(resourceName: "linkedUserOption1")
                } else if indexPath.row == 2 {
                    
                } else if indexPath.row == 3 {
                    cell.imageView?.image = #imageLiteral(resourceName: "inviteAndEarn")
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignoutCell") as! SignoutCell
            cell.signoutName.text = menuOptions[indexPath.section][indexPath.row]["name"]
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        
        return " "
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegue(withIdentifier: "showAccountsSegue", sender: self)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            // self.performSegue(withIdentifier: "showFaqSegue", sender: self) // Settings view
        } else if indexPath.section == 2 && indexPath.row == 1 {
            // self.performSegue(withIdentifier: "showFaqSegue", sender: self) // Linked User view
        } else if indexPath.section == 2 && indexPath.row == 2 {
            self.performSegue(withIdentifier: "showFaqSegue", sender: self)
        } else if indexPath.section == 2 && indexPath.row == 3 {
            self.performSegue(withIdentifier: "showReferralSegue", sender: self)
        } else if indexPath.section == 3 && indexPath.row == 0 {
            // Signout user
            TwoPenceAPI.sharedClient.logout()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
