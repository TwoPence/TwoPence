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
        [["name":"Settings"], ["name":"Sponsors"],  ["name": "FAQ"], ["name":"Invite a friend"]],
        [["name" : "Sign out"]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadUserProfile()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationItem.title = "More"
            navigationBar.tintColor = AppColor.Charcoal.color
            navigationBar.backIndicatorImage = UIImage(named: "left_chevron")
            navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "left_chevron")
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            navigationBar.barTintColor = UIColor.clear
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }
    }
    
    func loadUserProfile() {
        TwoPenceAPI.sharedClient.getProfile(success: { (profile: UserProfile) in
            self.userProfile = profile
            self.tableView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        tableView.register(UINib(nibName: "SignoutCell", bundle: nil), forCellReuseIdentifier: "SignoutCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 45
        self.tableView.tableFooterView = UIView()
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
                    cell.imageView?.image = #imageLiteral(resourceName: "settings")
                } else if indexPath.row == 1 {
                    cell.imageView?.image = #imageLiteral(resourceName: "sponsorIconGreen")
                } else if indexPath.row == 2 {
                    cell.imageView?.image = #imageLiteral(resourceName: "faq")
                } else if indexPath.row == 3 {
                    cell.imageView?.image = #imageLiteral(resourceName: "invite")
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
            self.performSegue(withIdentifier: "showSponsorsSegue", sender: self)
        } else if indexPath.section == 2 && indexPath.row == 2 {
            self.performSegue(withIdentifier: "showFaqSegue", sender: self)
        } else if indexPath.section == 2 && indexPath.row == 3 {
            self.performSegue(withIdentifier: "showReferralSegue", sender: self)
        } else if indexPath.section == 3 && indexPath.row == 0 {
            // Signout user
            TwoPenceAPI.sharedClient.logout()
        }
        
    }
}

