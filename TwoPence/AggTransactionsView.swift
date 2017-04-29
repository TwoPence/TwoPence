//
//  TransactionsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class AggTransactionsView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // var aggTransactions: [AggTransactions] = []
    var fakeTransactions: [String] = ["$25.76 transfered on 7/4", "$51.34 transfered on 8/6"]
    
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
        let menuItemCell = UINib(nibName: "AggTransactionsCell", bundle: nil)
        tableView.register(menuItemCell, forCellReuseIdentifier: "AggTransactionsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AggTransactionsCell", for: indexPath) as! AggTransactionsCell
//        let amount = aggTransactions[indexPath.row].amount
//        let date = aggTransactions[indexPath.row].date
//        cell.aggTransactionsLabel.text = "\(amount) transfer one \(date)"
        cell.aggTransactionsLabel.text = fakeTransactions[indexPath.row]
        return cell
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
