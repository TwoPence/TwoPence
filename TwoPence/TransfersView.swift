//
//  TransfersView.swift
//  TwoPence
//
//  Created by Will Gilman on 5/24/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

protocol TransfersViewDelegate {
    
    func navigateToTransactionsDetailViewController(selectedTransactions: [(date: Date, transactions: [Transaction])], isPending: Bool)
    
    func initiateTransferType(transferType: TransferType)
}

class TransfersView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    var delegate: TransfersViewDelegate?
    var transfers = [Transfer]() {
        didSet {
            groupedTransfers = Transfer.groupByEomDate(transfers: transfers)
            let totalSaved = transfers.map({$0.amount}).reduce(0, +)
            amountLabel.text = "Total: " + totalSaved.money(round: true)
        }
    }
    var groupedTransfers = [(eomDate: Date, transfers: [Transfer])]() {
        didSet {
            tableView.reloadData()
        }
    }
    var transferType: TransferType? {
        didSet {
            colorView.backgroundColor = transferType?.color
            setupEmptyTableState()
        }
    }
    var peekingBenView: PeekingBenView!
    var peekHeight: CGFloat = 80
    var previousScrollOffset: CGFloat = 0
    var emptyTableStateView: EmptyTableStateView!
    let sectionHeight: CGFloat = 25
    let dateFormatter = DateFormatter()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "TransfersView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        setupTableView()
        peekingBenView = PeekingBenView()
        tableView.addSubview(peekingBenView)
        setupPeekingBen()
        emptyTableStateView = EmptyTableStateView()
        emptyTableStateView.delegate = self
        amountLabel.textColor = AppColor.Charcoal.color
        amountLabel.font = UIFont(name: AppFontName.regular, size: 17)
    }
    
    func setupPeekingBen() {
        peekingBenView.frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.contentSize.width, height: peekHeight)
        peekingBenView.isHidden = true
    }
    
    func setupEmptyTableState() {
        emptyTableStateView.frame = tableView.frame
        tableView.backgroundView = emptyTableStateView
        if let type = transferType {
            switch type {
            case .Spending:
                emptyTableStateView.transferType = type
                emptyTableStateView.emptyStateImage = #imageLiteral(resourceName: "spendingIconGray")
                emptyTableStateView.text = AppCopy.firstSavings
                emptyTableStateView.actionButton.isHidden = true
            case .Jolt:
                emptyTableStateView.transferType = type
                emptyTableStateView.emptyStateImage = #imageLiteral(resourceName: "lightningboltGray")
                emptyTableStateView.text = AppCopy.firstJolt
                emptyTableStateView.action = "Jolt"
                emptyTableStateView.actionButton.isHidden = false
            case .Sponsor:
                emptyTableStateView.transferType = type
                emptyTableStateView.emptyStateImage = #imageLiteral(resourceName: "sponsorIconGray")
                emptyTableStateView.text = AppCopy.linkFirstSponsor
                emptyTableStateView.action = "Link a Sponsor"
                emptyTableStateView.actionButton.isHidden = false
            default: break
            }
        }
    }
    
    func setupTableView() {
        let transferCell = UINib(nibName: "TransferCell", bundle: nil)
        tableView.register(transferCell, forCellReuseIdentifier: "TransferCell")
        let pendingTransferCell = UINib(nibName: "PendingTransferCell", bundle: nil)
        tableView.register(pendingTransferCell, forCellReuseIdentifier: "PendingTransferCell")
        let matchedCell = UINib(nibName: "MatchedCell", bundle: nil)
        tableView.register(matchedCell, forCellReuseIdentifier: "MatchedCell")
        let joltCell = UINib(nibName: "JoltCell", bundle: nil)
        tableView.register(joltCell, forCellReuseIdentifier: "JoltCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 52
        tableView.tableFooterView = UIView()
    }
}

extension TransfersView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedTransfers.count
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
        
        let labelFrame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeight)
        let sectionLabel = UILabel(frame: labelFrame)
        dateFormatter.dateFormat = "MMMM YYYY"
        let dateText = dateFormatter.string(from: groupedTransfers[section].eomDate)
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
        let xfers = groupedTransfers[section].transfers
        if xfers.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        return xfers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transfer = groupedTransfers[indexPath.section].transfers[indexPath.row]
        let type = transfer.type
        let pending = transfer.pending
        
        if type == .Spending && pending == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PendingTransferCell", for: indexPath) as! PendingTransferCell
            cell.pendingTransfer = transfer
            return cell
            
        } else if type == .Spending && pending == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as! TransferCell
            cell.transfer = transfer
            return cell
            
        } else if type == .Sponsor {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchedCell", for: indexPath) as! MatchedCell
            cell.match = transfer
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            return cell
            
        } else if type == .Jolt {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JoltCell", for: indexPath) as! JoltCell
            cell.jolt = transfer
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            return cell
            
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pending = groupedTransfers[indexPath.section].transfers[indexPath.row].pending
        let transactions = groupedTransfers[indexPath.section].transfers[indexPath.row].transactions
        let groupedTrans = Transaction.groupByDate(transactions: transactions)
        delegate?.navigateToTransactionsDetailViewController(selectedTransactions: groupedTrans, isPending: pending)
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

extension TransfersView: EmptyTableStateViewDelegate {
    
    func initiateTransferType(transferType: TransferType) {
        delegate?.initiateTransferType(transferType: transferType)
    }
}
