//
//  SavingsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

@objc protocol SavingsViewDelegate {
    
    @objc optional func didTapJoltButton(didTap: Bool)
}

class SavingsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var totalSavedLabel: UILabel!
    @IBOutlet weak var totalSavedLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var savedLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var savedLabelXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var matchedLabel: UILabel!
    @IBOutlet weak var matchedLabelYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var matchedSavedLabel: UILabel!
    @IBOutlet weak var matchedSavedLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var matchedSavedLabelXConstraint: NSLayoutConstraint!
    
    weak var delegate: SavingsViewDelegate?
    var previousScrollOffset: CGFloat = 0
    
    let headerMaxHeight: CGFloat = 300
    let headerMinHeight: CGFloat = 150
    
    let totalSavedLabelMaxSpace: CGFloat = 50
    let totalSavedLabelMinSpace: CGFloat = 5
    let totalSavedLabelMinScale: CGFloat = 0.7
    
    let savedLabelMaxY: CGFloat = 55
    let savedLabelMinY: CGFloat = 0
    let savedLabelMaxX: CGFloat = 95
    let savedLabelMinX: CGFloat = 0
    let savedLabelMinScale: CGFloat = 0.65
    
    let matchedLabelsMaxY: CGFloat = 55
    let matchedLabelsMinY: CGFloat = 0
    let matchedLabelMinScale: CGFloat = 0.2
    let matchedSavedLabelMaxX: CGFloat = 80
    let matchedSavedLabelMinX: CGFloat = 45
    let matchedSavedLabelMinScale: CGFloat = 0.7
    
    @IBOutlet weak var joltMessageLabel: UILabel!
    @IBOutlet weak var joltButton: UIButton!
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let collectionCell = UINib(nibName: "MonthCell", bundle: nil)
        collectionView.register(collectionCell, forCellWithReuseIdentifier: "MonthCell")
        collectionView.dataSource = self
        collectionView.scrollToItem(at: IndexPath(row: 11, section: 0), at: .right, animated: false)
        
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.itemSize = CGSize(width: 50, height: 50)
        
        joltButton.backgroundColor = .clear
        joltButton.layer.cornerRadius = 5
        joltButton.layer.borderWidth = 1
        joltButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        joltButton.layer.borderColor = UIColor.white.cgColor
    }
}
    
extension SavingsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "\(indexPath.row)"
        return cell
    }
    
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
        
        // Move and shrink totalSavedLabel
        let spaceDiff = totalSavedLabelMaxSpace - totalSavedLabelMinSpace
        self.totalSavedLabelTopConstraint.constant = percentage * spaceDiff + totalSavedLabelMinSpace
        let totalSavedScale = percentage * (1 - totalSavedLabelMinScale) + totalSavedLabelMinScale
        self.totalSavedLabel.transform = CGAffineTransform(scaleX: totalSavedScale, y: totalSavedScale)
        
        // Move, shrink and disappear the matchedLabel
        self.matchedLabelYConstraint.constant = percentage * (matchedLabelsMaxY - matchedLabelsMinY) + matchedLabelsMinY
        let matchedScale = percentage * (1 - matchedLabelMinScale) + matchedLabelMinScale
        self.matchedLabel.transform = CGAffineTransform(scaleX: matchedScale, y: matchedScale)
        self.matchedLabel.alpha = percentage
        
        // Move and shrink the matchedSavedLabel
        self.matchedSavedLabelYConstraint.constant = percentage * (matchedLabelsMaxY - matchedLabelsMinY) + matchedLabelsMinY
        self.matchedSavedLabelXConstraint.constant = (matchedSavedLabelMaxX - matchedSavedLabelMinX) * (1 - percentage) + matchedSavedLabelMinX
        let matchedSavedScale = percentage * (1 - matchedSavedLabelMinScale) + matchedSavedLabelMinScale
        self.matchedLabel.transform = CGAffineTransform(scaleX: matchedSavedScale, y: matchedSavedScale)
        
        // Move and shrink savedLabel
        self.savedLabelYConstraint.constant = percentage * savedLabelMaxY + savedLabelMinY
        self.savedLabelXConstraint.constant = (1 - percentage) * savedLabelMaxX + savedLabelMinX
        let savedScale = percentage * (1 - savedLabelMinScale) + savedLabelMinScale
        self.savedLabel.transform = CGAffineTransform(scaleX: savedScale, y: savedScale)
        
        // Disappear Jolt message and button
        self.joltMessageLabel.alpha = percentage
        self.joltButton.isEnabled = false
        self.joltButton.alpha = percentage
    }

}

extension SavingsView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthCell
        return cell
    }
    
    
    
}
