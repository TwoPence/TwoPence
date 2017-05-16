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
    var editable: Bool = false
    
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
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeight)
        let sectionView = UIView(frame: frame)
        sectionView.backgroundColor = AppColor.PaleGray.color
        
        let labelFrame = CGRect(x: 16, y: 0, width: tableView.bounds.width - 16, height: sectionHeight)
        let sectionLabel = UILabel(frame: labelFrame)
        dateFormatter.dateStyle = .long
        let dateText = dateFormatter.string(from: groupedTransactions[section].date)
        sectionLabel.text = dateText.uppercased()
        sectionLabel.font = UIFont(name: AppFontName.regular, size: 11)
        sectionLabel.textAlignment = .left
        sectionView.addSubview(sectionLabel)
        
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if editable {
            let skip = UITableViewRowAction(style: .destructive, title: "Skip") { (action: UITableViewRowAction, indexPath: IndexPath) in
                print("User tapped skip")
                // POST call to API to update transaction status to "skipped".
                self.groupedTransactions[indexPath.section].transactions.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            return [skip]
        } else {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Nothing here.
    }

}
