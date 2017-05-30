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

    @IBOutlet weak var referralLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shareButton: UIButton!
    
    var contacts = [CNContact]()
    var selectedContacts = Set<CNContact>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewAndCell()
        
        referralLabel.textColor = AppColor.Charcoal.color
        
        shareButton.backgroundColor = UIColor.white
        shareButton.layer.cornerRadius = 4
        shareButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        shareButton.setTitleColor(AppColor.DarkSeaGreen.color, for: .normal)

        shareButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
        shareButton.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
        shareButton.layer.borderWidth = 1
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
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
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ReferralContactCell
        
        if selectedCell.selectedButton.tag == 0 {
            selectedCell.selectedButton.tag = 1
            selectedCell.selectedButton.backgroundColor = AppColor.DarkSeaGreen.color
            selectedContacts.insert(selectedCell.contact)
        } else {
            selectedCell.selectedButton.tag = 0
            selectedCell.selectedButton.backgroundColor = UIColor.clear
            selectedContacts.remove(selectedCell.contact)
        }
        
        
        if selectedContacts.count > 0 {
            shareButton.setTitle("Share with \(selectedContacts.count) friends", for: .normal)
        } else {
            shareButton.setTitle("Share a link!", for: .normal)
        }
    }
}
