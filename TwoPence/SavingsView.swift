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
    
    func didTapJoltButton(didTap: Bool)
    
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
    @IBOutlet weak var savedAmountLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var savedLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var savedLabelXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var matchedLabel: UILabel!
    @IBOutlet weak var matchedLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var matchedLabelXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var matchedAmountLabel: UILabel!
    @IBOutlet weak var matchedAmountLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var matchedAmountLabelXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var joltMessageLabel: UILabel!
    @IBOutlet weak var joltButton: UIButton!
    @IBOutlet weak var joltDividerView: UIView!
    
    var delegate: SavingsViewDelegate?
    
    var previousScrollOffset: CGFloat = 0
    var aggTransactions = [AggTransactions]()
    var filtered = [(month: String?, aggTransactions: [AggTransactions])]()
    var monthlyAggTransactions = [MonthlyAggTransactions]()
    var selectedMonth: String?
    
    let headerMaxHeight: CGFloat = 300
    let headerMinHeight: CGFloat = 165
    
    let savedAmountLabelMaxSpace: CGFloat = 50
    let savedAmountLabelMinSpace: CGFloat = 5
    let savedAmountLabelMinScale: CGFloat = 0.7
    
    // These constants are with respect to the location of the savedAmountLabel.
    let savedLabelMaxY: CGFloat = 55
    let savedLabelMinY: CGFloat = 30
    let savedLabelMaxX: CGFloat = 0
    let savedLabelMinX: CGFloat = 0
    let savedLabelMinScale: CGFloat = 0.7
    
    let matchedLabelsMaxY: CGFloat = 55
    let matchedLabelsMinY: CGFloat = 30
    
    // TODO: Replace X constraints with a relative constraint between matchedLabel and matchedAmountLabel
    let matchedLabelMaxX: CGFloat = -55
    let matchedLabelMinX: CGFloat = -35
    let matchedLabelMinScale: CGFloat = 0.7
    
    let matchedAmountLabelMaxX: CGFloat = 50
    let matchedAmountLabelMinX: CGFloat = 40
    let matchedAmountLabelMinScale: CGFloat = 0.7
    
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
        headerView.backgroundColor = UIColor(red: 21/255, green: 140/255, blue: 81/255, alpha: 1.0)
        
        selectedMonth = currentMonth()
        
        setupTableView()
        setupCollectionView()
        setupJoltButton()
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
        // collectionView.scrollToItem(at: IndexPath(row: 11, section: 0), at: .right, animated: false)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 30
        collectionViewFlowLayout.itemSize = CGSize(width: 50, height: 50)
    }
    
    func setupJoltButton() {
        joltButton.backgroundColor = .clear
        joltButton.layer.cornerRadius = 5
        joltButton.layer.borderWidth = 1
        joltButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        joltButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func loadAggTransactions() {
        TwoPenceAPI.sharedClient.getAggTransactions(success: { (aggTransactions: [AggTransactions]) in
            self.aggTransactions = aggTransactions
            self.monthlyAggTransactions = MonthlyAggTransactions.withArray(aggTransactions: aggTransactions)
            self.filtered = [(self.selectedMonth, aggTransactions.filter({$0.month == self.selectedMonth}))]
            self.tableView.reloadData()
            self.collectionView.reloadData()
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
        matchedAmountLabel.text = "\(totalMatched)"
    }
    
    @IBAction func didTapJoltButton(_ sender: UIButton) {
        delegate?.didTapJoltButton(didTap: true)
    }
    
}

extension SavingsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableViewHeaderHeight)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = UIColor.lightGray
        
        let monthLabel = UILabel(frame: frame)
        monthLabel.text = filtered[section].month
        monthLabel.font = monthLabel.font.withSize(13)
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
                // Hide the divider immediately once scrolling down beings, otherwise it looks weird.
                self.joltDividerView.alpha = 0.0
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
            // Show the divider once the header has re-expanded.
            self.joltDividerView.alpha = 0.8
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
        
        // savedAmountLabel: Move Up and Shrink
        let spaceDiff = savedAmountLabelMaxSpace - savedAmountLabelMinSpace
        self.savedAmountLabelTopConstraint.constant = percentage * spaceDiff + savedAmountLabelMinSpace
        let savedAmountScale = percentage * (1 - savedAmountLabelMinScale) + savedAmountLabelMinScale
        self.savedAmountLabel.transform = CGAffineTransform(scaleX: savedAmountScale, y: savedAmountScale)
        
        // savedLabel: Move Up and Shrink
        self.savedLabelYConstraint.constant = percentage * (savedLabelMaxY - savedLabelMinY) + savedLabelMinY
        self.savedLabelXConstraint.constant = (1 - percentage) * savedLabelMaxX + savedLabelMinX
        let savedLabelScale = percentage * (1 - savedLabelMinScale) + savedLabelMinScale
        self.savedLabel.transform = CGAffineTransform(scaleX: savedLabelScale, y: savedLabelScale)
        
        // matchedAmountLabel: Move Up and Right, Shrink
        self.matchedAmountLabelYConstraint.constant = percentage * (matchedLabelsMaxY - matchedLabelsMinY) + matchedLabelsMinY
        self.matchedAmountLabelXConstraint.constant = matchedAmountLabelMaxX - (1 - percentage) * (matchedAmountLabelMaxX - matchedAmountLabelMinX)
        let matchedAmountScale = percentage * (1 - matchedAmountLabelMinScale) + matchedAmountLabelMinScale
        self.matchedAmountLabel.transform = CGAffineTransform(scaleX: matchedAmountScale, y: matchedAmountScale)
        
        // matchedLabel: Move Up and Left, Shrink
        self.matchedLabelYConstraint.constant = percentage * (matchedLabelsMaxY - matchedLabelsMinY) + matchedLabelsMinY
        self.matchedLabelXConstraint.constant = matchedLabelMaxX - (1 - percentage) * (matchedLabelMaxX - matchedLabelMinX)
        let matchedLabelScale = percentage * (1 - matchedLabelMinScale) + matchedLabelMinScale
        self.matchedLabel.transform = CGAffineTransform(scaleX: matchedLabelScale, y: matchedLabelScale)
 
        // Jolt Section: Ghost button and message
        self.joltMessageLabel.alpha = (percentage * percentage)
        self.joltButton.alpha = (percentage * percentage)
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
