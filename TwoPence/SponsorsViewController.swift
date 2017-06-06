//
//  SponsorsViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 5/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class SponsorsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var colorView: UIView!
    
    var sponsors = [Sponsor]() {
        didSet {
            tableView.reloadData()
        }
    }
    var emptyTableStateView: EmptyTableStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Sponsors"
        colorView.backgroundColor = AppColor.Blue.color
        loadSponsors()
        setupTableView()
        setupEmptyState()
    }
    
    func loadSponsors() {
        TwoPenceAPI.sharedClient.getSponsors(success: { (sponsors: [Sponsor]) in
            self.sponsors = sponsors
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func setupTableView() {
        let cell = UINib(nibName: "SponsorCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "SponsorCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func setupEmptyState() {
        emptyTableStateView = EmptyTableStateView()
        emptyTableStateView.delegate = self
        emptyTableStateView.frame = tableView.frame
        tableView.backgroundView = emptyTableStateView
        emptyTableStateView.transferType = .Sponsor
        emptyTableStateView.emptyStateImage = #imageLiteral(resourceName: "sponsorIconGray")
        emptyTableStateView.text = AppCopy.linkFirstSponsor
        emptyTableStateView.actionButton.isHidden = false
    }
}

extension SponsorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sponsors.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        return sponsors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SponsorCell", for: indexPath) as! SponsorCell
        cell.sponsor = sponsors[indexPath.row]
        return cell
    }
}

extension SponsorsViewController: EmptyTableStateViewDelegate {
    
    func initiateTransferType(transferType: TransferType) {
        self.performSegue(withIdentifier: "AddSponsorSegue", sender: nil)
    }
}

