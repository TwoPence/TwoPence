//
//  ReferralViewController.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/8/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class ReferralViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [CNContact]()
    var selectedContacts = Set<CNContact>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewAndCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareLink(_ sender: Any) {
        let shareText = "Unique link for user and some fun text!"
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}

extension ReferralViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableViewAndCell(){
        let cell = UINib(nibName: "ReferralContactCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "ReferralContactCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        
        Utils.findContactsOnBackgroundThread{ (contacts) in
            self.contacts = contacts!
            self.tableView.reloadData()
        }
    }
    
    // For selectedContacts, make an API call to send them an email.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferralContactCell") as! ReferralContactCell
        cell.contact = contacts[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ReferralContactCell
        if selectedCell.selectedIcon.isHidden {
            selectedCell.selectedIcon.isHidden = false
            selectedContacts.insert(selectedCell.contact)
        } else {
            selectedCell.selectedIcon.isHidden = true
            selectedContacts.remove(selectedCell.contact)
        }
    }
}
