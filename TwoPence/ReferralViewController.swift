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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contacts = [CNContact]()
    var filteredContacts = [CNContact]() {
        didSet {
            tableView.reloadData()
        }
    }

    var selectedContacts = Set<CNContact>()
    var selectedCells = [Int : Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        loadContacts()
        setupTableView()
        setupSearchBar()
        setupDisplay()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            let closeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(cancel))
            closeBtn.tintColor = UIColor.black
            navigationItem.rightBarButtonItem = closeBtn
            navigationBar.tintColor = AppColor.Charcoal.color
            navigationBar.backIndicatorImage = UIImage(named: "left_chevron")
            navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "left_chevron")
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            navigationBar.barTintColor = UIColor.white
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }
    }
    
    func loadContacts() {
        ContactsAPI.sharedClient.findAllContacts { (contacts: [CNContact]) in
            self.contacts = contacts
            self.filteredContacts = contacts
        }
    }
    
    func setupTableView() {
        let cell = UINib(nibName: "ContactCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "ContactCell")
        tableView.rowHeight = 72.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.white
        searchBar.barTintColor = UIColor.white
        searchBar.tintColor = AppColor.DarkSeaGreen.color
        searchBar.placeholder = "Search Contacts"
        // Get rid of gray x next to cancel button.
    }
    
    func setupDisplay() {
        referralLabel.textColor = AppColor.Charcoal.color
        
        shareButton.backgroundColor = UIColor.white
        shareButton.layer.cornerRadius = 4
        shareButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        shareButton.setTitleColor(AppColor.DarkSeaGreen.color, for: .normal)
        
        shareButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
        shareButton.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
        shareButton.layer.borderWidth = 1
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareLink(_ sender: Any) {
        let shareText = "Unique link for user and some fun text!"
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}

extension ReferralViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            ContactsAPI.sharedClient.findContactsWithName(searchText, { (contacts: [CNContact]) in
                self.filteredContacts = contacts
            })
        } else {
            self.filteredContacts = self.contacts
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        filteredContacts = contacts
        searchBar.resignFirstResponder()
    }
}

extension ReferralViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        cell.contact = filteredContacts[indexPath.row]
        cell.isContactSelected = selectedCells[indexPath.row] ?? false
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        if cell.isContactSelected == false {
            cell.isContactSelected = true
            selectedCells[indexPath.row] = true
            selectedContacts.insert(cell.contact)
        } else {
            cell.isContactSelected = false
            selectedCells[indexPath.row] = false
            selectedContacts.remove(cell.contact)
        }
        
        if selectedContacts.count > 0 {
            shareButton.setTitle("Share with \(selectedContacts.count) friends", for: .normal)
        } else {
            shareButton.setTitle("Share a link!", for: .normal)
        }
    }
}
