//
//  TransactionsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol TransactionsViewDelegate {
    
    func didSkipTransaction(amountSkipped: Double)
}

class TransactionsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    var delegate: TransactionsViewDelegate?
    let dateFormatter = DateFormatter()
    
    var groupedTransactions = [(date: Date, transactions: [Transaction])]() {
        didSet {
            let transactions = groupedTransactions.map({$0.transactions}).flatMap({$0})
            totalSaved = transactions.filter({$0.status != .Skipped}).map({$0.amountSaved}).reduce(0, +)
            tableView.reloadData()
        }
    }
    let sectionHeight: CGFloat = 25
    var peekingBenView: PeekingBenView!
    var peekHeight: CGFloat = 80
    var previousScrollOffset: CGFloat = 0
    var totalSaved: Double = 0 {
        didSet {
            amountLabel.text = totalSaved.money()
        }
    }
    
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
        peekingBenView = PeekingBenView()
        tableView.addSubview(peekingBenView)
        amountLabel.textColor = AppColor.Charcoal.color
        amountLabel.font = UIFont(name: AppFontName.regular, size: 17)
        colorView.backgroundColor = AppColor.PaleGreen.color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        peekingBenView.frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.contentSize.width, height: peekHeight)
        peekingBenView.isHidden = true
    }
    
    func setupTableView() {
        let cell = UINib(nibName: "TransactionCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "TransactionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.tableFooterView = UIView()
    }
}

extension TransactionsView: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeight)
        let sectionView = UIView(frame: frame)
        sectionView.backgroundColor = AppColor.PaleGray.color
        
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        let bottomBorder = UIView(frame: CGRect(x: 0, y: sectionView.bounds.height - 1, width: tableView.bounds.width, height: 1))
        topBorder.backgroundColor = AppColor.LightBlueGray.color
        bottomBorder.backgroundColor = AppColor.LightBlueGray.color
        sectionView.addSubview(topBorder)
        sectionView.addSubview(bottomBorder)

        let labelFrame = CGRect(x: 16, y: 0, width: tableView.bounds.width - 16, height: sectionHeight)
        let sectionLabel = UILabel(frame: labelFrame)
        dateFormatter.dateStyle = .long
        let dateText = dateFormatter.string(from: groupedTransactions[section].date)
        sectionLabel.text = dateText
        sectionLabel.font = UIFont(name: AppFontName.regular, size: 11)
        sectionLabel.textColor = AppColor.Charcoal.color
        sectionLabel.textAlignment = .center
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
        cell.delegate = self
        cell.transaction = groupedTransactions[indexPath.section].transactions[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let trans = groupedTransactions[indexPath.section].transactions[indexPath.row]
        
        if trans.status == .Queued {
            guard orientation == .right else { return nil }
            let skipAction = SwipeAction(style: .destructive, title: "Skip", handler: { (action: SwipeAction, indexPath: IndexPath) in
                // POST status to API.
                
                // Notify user they removed amount from their savings.
                self.delegate?.didSkipTransaction(amountSkipped: trans.amountSaved)
                
                trans.status = .Skipped
                self.groupedTransactions[indexPath.section].transactions[indexPath.row] = trans
                let cell = tableView.cellForRow(at: indexPath) as! TransactionCell
                cell.transaction = trans
            })
            skipAction.backgroundColor = AppColor.Red.color
            skipAction.font = UIFont(name: AppFontName.regular, size: 17)
            skipAction.textColor = UIColor.white
            return [skipAction]
            
        } else if trans.status == .Skipped {
            guard orientation == .left else { return nil }
            let undoAction = SwipeAction(style: .default, title: "Undo", handler: { (action: SwipeAction, indexPath: IndexPath) in
                // POST status to API
                
                trans.status = .Queued
                self.groupedTransactions[indexPath.section].transactions[indexPath.row] = trans
                let cell = tableView.cellForRow(at: indexPath) as! TransactionCell
                cell.transaction = trans
            })
            undoAction.backgroundColor = UIColor.blue
            undoAction.font = UIFont(name: AppFontName.regular, size: 17)
            undoAction.textColor = UIColor.white
            return [undoAction]
        } else {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        return options
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        let didScrollToEnd = scrollView.contentOffset.y > scrollOffsetThreshold
        let isScrollingDown = (scrollView.contentOffset.y - previousScrollOffset) > 0
        let canScroll = scrollView.contentSize.height > tableView.bounds.size.height
        
        if canScroll && didScrollToEnd && tableView.isDragging && isScrollingDown {
            // Show peeking
            let scrollableRange = tableView.contentSize.height - tableView.bounds.height
            let bounceAmount = scrollView.contentOffset.y - scrollableRange
            let peekAmount = min(bounceAmount, peekHeight)
            let y = tableView.contentSize.height + bounceAmount - peekAmount
            let frame = CGRect(x: 0, y: y, width: tableView.contentSize.width, height: peekHeight)
            peekingBenView.frame = frame
            peekingBenView.isHidden = false
        }
        
        previousScrollOffset = scrollView.contentOffset.y
    }

}
