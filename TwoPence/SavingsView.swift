//
//  SavingsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Money

protocol SavingsViewDelegate {
    
    func navigateToTransactionsDetailViewController(selectedTransactions: [Transaction])
}

class SavingsView: UIView, JoltViewDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    @IBOutlet weak var savedAmountLabel: UILabel!
    @IBOutlet weak var matchedAmountLabel: UILabel!
    
    @IBOutlet weak var savedAmountLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalSavedLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var matchedAmountLabelTopConstraint: NSLayoutConstraint!
    
    var delegate: SavingsViewDelegate?
    
    var previousScrollOffset: CGFloat = 0
    var aggTransactions = [AggTransactions]()
    var filtered = [(month: String?, aggTransactions: [AggTransactions])]()
    var monthlyAggTransactions = [MonthlyAggTransactions]()
    var selectedMonth: String?
    
    let headerMaxHeight: CGFloat = 340
    let headerMinHeight: CGFloat = 235
    
    let savedAmountLabelTopConstraintMax: CGFloat = 94
    let savedAmountLabelTopConstraintMin: CGFloat = 40

    let totalSavedLabelBottomConstraintMax: CGFloat = 8
    let totalSavedLabelBottomConstraintMin: CGFloat = -8
    
    let matchedAmountLabelTopConstraintMax: CGFloat = 48
    let matchedAmountLabelTopConstraintMin: CGFloat = -8
    
    let savedAmountLabelMinScale: CGFloat = 0.4
    
    let tableViewHeaderHeight: CGFloat = 25
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "SavingsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        headerHeightConstraint.constant = headerMaxHeight
        
        headerView.backgroundColor = AppColor.DarkGreen.color
        
        selectedMonth = currentMonth()
        
        setupTableView()
        setupCollectionView()
        loadAggTransactions()
    }
    
    func setupTableView() {
        let transferCell = UINib(nibName: "TransferCell", bundle: nil)
        tableView.register(transferCell, forCellReuseIdentifier: "TransferCell")
        let pendingTransferCell = UINib(nibName: "PendingTransferCell", bundle: nil)
        tableView.register(pendingTransferCell, forCellReuseIdentifier: "PendingTransferCell")
        let matchedCell = UINib(nibName: "MatchedCell", bundle: nil)
        tableView.register(matchedCell, forCellReuseIdentifier: "MatchedCell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "MonthSection")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupCollectionView() {
        let collectionCell = UINib(nibName: "MonthCell", bundle: nil)
        collectionView.register(collectionCell, forCellWithReuseIdentifier: "MonthCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 32
        collectionViewFlowLayout.itemSize = CGSize(width: 66, height: 45)
    }
    
    func loadAggTransactions() {
        TwoPenceAPI.sharedClient.getAggTransactions(success: { (aggTransactions: [AggTransactions]) in
            self.aggTransactions = aggTransactions
            self.monthlyAggTransactions = MonthlyAggTransactions.withArray(aggTransactions: aggTransactions)
            self.filtered = [(self.selectedMonth, aggTransactions.filter({$0.month == self.selectedMonth}))]
            self.tableView.reloadData()
            self.collectionView.reloadData()
            
            let indexPath = IndexPath(row: self.monthlyAggTransactions.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            
            self.setupHeaderElements()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func currentMonth() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
    
    func setupHeaderElements() {
        let allSavings = aggTransactions.map({$0.amount}) as! [Money]
        let totalSaved = allSavings.reduce(0, +)
        let allMatched = aggTransactions.filter({$0.aggType == "MATCHED"}).map({$0.amount}) as! [Money]
        let totalMatched = allMatched.reduce(0, +)
        
        savedAmountLabel.text = "\(totalSaved)"
        matchedAmountLabel.text = "\(totalMatched) Matched"
    }
}

extension SavingsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableViewHeaderHeight)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = UIColor(red: 244/255, green: 245/255, blue: 246/255, alpha: 1.0)
        
        let monthLabel = UILabel(frame: frame)
        monthLabel.text = filtered[section].month
        monthLabel.font = UIFont(name: AppFontName.regular, size: 11)
        monthLabel.textAlignment = .center
        headerView.addSubview(monthLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered[section].aggTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trans = filtered[indexPath.section].aggTransactions
        
        if trans[indexPath.row].aggType! == "PENDING" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PendingTransferCell", for: indexPath) as! PendingTransferCell
            cell.pendingTransfer = trans[indexPath.row]
            return cell
        } else if trans[indexPath.row].aggType! == "MATCHED" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchedCell", for: indexPath) as! MatchedCell
            cell.match = trans[indexPath.row]
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as! TransferCell
            cell.transfer = trans[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trans = filtered[indexPath.section].aggTransactions[indexPath.row].transactions
        delegate?.navigateToTransactionsDetailViewController(selectedTransactions: trans!)
    }
    
    // -------------------- Begin Methods for Resizing Header --------------------
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            var newHeight = self.headerHeightConstraint.constant
            
            if isScrollingDown {
                newHeight = max(self.headerMinHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.headerMaxHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
        }
        
        self.previousScrollOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.headerMaxHeight - self.headerMinHeight
        let midpoint = self.headerMinHeight + range / 2
        
        if self.headerHeightConstraint.constant > midpoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - headerMinHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func expandHeader() {
        UIView.animate(withDuration: 0.2) {
            self.headerHeightConstraint.constant = self.headerMaxHeight
            self.updateHeader()
        }
    }
    
    func collapseHeader() {
        UIView.animate(withDuration: 0.2) {
            self.headerHeightConstraint.constant = self.headerMinHeight
            self.updateHeader()
        }
    }
    
    func updateHeader() {
        let range = headerMaxHeight - headerMinHeight
        let openAmount = self.headerHeightConstraint.constant - headerMinHeight
        let percentage = openAmount / range
        
        let amountRange = savedAmountLabelTopConstraintMax - savedAmountLabelTopConstraintMin
        savedAmountLabelTopConstraint.constant = percentage * amountRange + savedAmountLabelTopConstraintMin
        
        let topRange = totalSavedLabelBottomConstraintMax - totalSavedLabelBottomConstraintMin
        totalSavedLabelBottomConstraint.constant = percentage * topRange + totalSavedLabelBottomConstraintMin
        
        let matchedRange = matchedAmountLabelTopConstraintMax - matchedAmountLabelTopConstraintMin
        matchedAmountLabelTopConstraint.constant = percentage * matchedRange + matchedAmountLabelTopConstraintMin
        
        let savedAmountScale = percentage * (1 - savedAmountLabelMinScale) + savedAmountLabelMinScale
        savedAmountLabel.transform = CGAffineTransform(scaleX: savedAmountScale, y: savedAmountScale)
    }
}

extension SavingsView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthlyAggTransactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthCell
        cell.monthlyAggTransactions = monthlyAggTransactions[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMonth = monthlyAggTransactions[indexPath.row].month
        filtered = [(selectedMonth, aggTransactions.filter({$0.month == selectedMonth}))]
        tableView.reloadData()
    }
    
}
