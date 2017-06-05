//
//  AddSponsorViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 5/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class AddSponsorViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var colorView: UIView!
    
    var contacts = [CNContact]()
    var filteredContacts = [CNContact]() {
        didSet {
            tableView.reloadData()
        }
    }
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        colorView.backgroundColor = AppColor.Blue.color
        setupNavigationBar()
        loadContacts()
        setupTableView()
        setupSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationItem.title = "Link a Sponsor"
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
            navigationBar.isTranslucent = false
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
        tableView.dataSource = self
        tableView.delegate = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddSponsorDetailViewController {
            let addSponsorDetailViewController = segue.destination as! AddSponsorDetailViewController
            addSponsorDetailViewController.contact = sender as! CNContact
        }
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddSponsorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.disableButton()
        cell.contact = filteredContacts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = filteredContacts[indexPath.row]
        performSegue(withIdentifier: "AddSponsorDetailSegue", sender: contact)
    }
}

extension AddSponsorViewController: UISearchBarDelegate {
    
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
