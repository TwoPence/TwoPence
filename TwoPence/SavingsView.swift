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

class SavingsView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: SavingsViewDelegate?
    var previousScrollOffset: CGFloat = 0
    
    let headerMaxHeight: CGFloat = 350
    let headerMinHeight: CGFloat = 200
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func onJoltTap(_ sender: UIButton) {
        delegate?.didTapJoltButton?(didTap: true)
    }
    
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
                // Update header
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
            // Update header
        }
    }
    
    func collapseHeader() {
        UIView.animate(withDuration: 0.2) { 
            self.headerHeightConstraint.constant = self.headerMinHeight
            // Update header
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
