//
//  SettingsViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var userProfile: UserProfile?
    
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
        
        TwoPenceAPI.sharedClient.getProfile(success: { (profile) in
            self.userProfile = profile
            self.tableView.reloadData()
            self.animateTableLoad()
        }) { (error) in
            
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.userProfile = userProfile
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
                    cell.imageView?.image = #imageLiteral(resourceName: "faq")
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
    
    func animateTableLoad() {
        let cells = self.tableView.visibleCells
        let tableWidth: CGFloat = self.tableView.bounds.size.width
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
        }
        
        var index = 0
        for m in cells {
            let cell: UITableViewCell = m as UITableViewCell
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: ({
                cell.transform = CGAffineTransform.identity
            }), completion: nil)
            
            index += 1
        }
    }
}

