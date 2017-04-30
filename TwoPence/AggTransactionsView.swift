//
//  TransactionsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

protocol AggTransactionsViewDelegate {
    
    func navigateToTransactionsDetailViewController(selectedTransactions: [Transaction])
}

class AggTransactionsView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var aggTransactions: [AggTransactions] = []
    var delegate: AggTransactionsViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "AggTransactionsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func awakeFromNib() {
        initFakeAggTransactions() // REMOVE: Testing only
        let cell = UINib(nibName: "AggTransactionsCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "AggTransactionsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aggTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AggTransactionsCell", for: indexPath) as! AggTransactionsCell
        cell.aggTransactions = aggTransactions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.navigateToTransactionsDetailViewController(selectedTransactions: aggTransactions[indexPath.row].transactions!)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // REMOVE: --------- Testing only ---------
    private func initFakeAggTransactions() {
        let pendingTransactions = [
            Transaction(amount: 81.45, amountSaved: 8.15, date: Date(), merchant: "Footlocker", status: "Queued", pending: true)
        ]
        let transferredTransactions = [
            Transaction(amount: 51.67, amountSaved: 5.17, date: Date(), merchant: "Macy's", status: "Queued", pending: false),
            Transaction(amount: 32.11, amountSaved: 3.21, date: Date(), merchant: "Black Bear Diner", status: "Queued", pending: false),
            Transaction(amount: 125.29, amountSaved: 12.53, date: Date(), merchant: "K&L Wines", status: "Processed", pending: false),
            Transaction(amount: 2.95, amountSaved: 0.30, date: Date(), merchant: "Starbucks", status: "Processed", pending: false)
        ]
        let unassignedTransactions = [
            Transaction(amount: 2500.0, amountSaved: 0, date: Date(), merchant: "Auto-Deposit", status: "Skipped", pending: false)
        ]
        
        aggTransactions.append(AggTransactions(amount: 0, date: Date(), transactions: pendingTransactions, aggType: "Pending"))
        aggTransactions.append(AggTransactions(amount: 21.21, date: Date(), transactions: transferredTransactions, aggType: "Transferred"))
        aggTransactions.append(AggTransactions(amount: 0, date: Date(), transactions: unassignedTransactions, aggType: "Unassigned"))
    }
    // ------------------------------------

}
