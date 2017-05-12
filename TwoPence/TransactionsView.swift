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
    
    let sectionHeight: CGFloat = 25
    let dateFormatter = DateFormatter()
    
    var groupedTransactions = [(date: Date, transactions: [Transaction])]()
//    var transactions = [Transaction]()
    
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
        tableView.estimatedRowHeight = 80.0
    }
}

extension TransactionsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: sectionHeight)
        let sectionView = UIView(frame: frame)
        sectionView.backgroundColor = UIColor(red: 147/255, green: 159/255, blue: 174/255, alpha: 0.1)
        
        let sectionLabel = UILabel(frame: frame)
        dateFormatter.dateStyle = .long
        let dateText = dateFormatter.string(from: groupedTransactions[section].date)
        sectionLabel.text = dateText.uppercased()
        sectionLabel.font = UIFont(name: "Lato-Regular", size: 11)
        sectionLabel.textAlignment = .left
        sectionView.addSubview(sectionLabel)
        
        let leftConstraint = NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1.0, constant: 16)
        sectionView.addConstraint(leftConstraint)
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedTransactions[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.transaction = groupedTransactions[indexPath.section].transactions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("called!")
        let skip = UITableViewRowAction(style: .destructive, title: "Skip") { (action: UITableViewRowAction,
            indexPath: IndexPath) in
            print("User tapped skip")
            // POST call to API to update transaction status to "skipped".
        }
        return [skip]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Nothing here.
    }

}
