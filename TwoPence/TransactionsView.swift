//
//  TransactionsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class TransactionsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let sectionHeight: CGFloat = 30
    let dateFormatter = DateFormatter()
    
    var displayTransactions = [(date: Date, transactions: [Transaction])]()
    var transactions = [Transaction]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "TransactionsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        setupTableView()
    }
    
    
    func setupTableView() {
        let cell = UINib(nibName: "TransactionCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "TransactionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
    }
}

extension TransactionsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayTransactions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: sectionHeight)
        let sectionView = UIView(frame: frame)
        sectionView.backgroundColor = UIColor.lightGray
        
        let sectionLabel = UILabel(frame: frame)
        dateFormatter.dateStyle = .long
        sectionLabel.text = dateFormatter.string(from: displayTransactions[section].date)
        sectionLabel.font = sectionLabel.font.withSize(13)
        sectionLabel.textAlignment = .center
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayTransactions[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.transaction = displayTransactions[indexPath.section].transactions[indexPath.row]
        return cell
    }

}
