//
//  DashboardView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

protocol DashboardViewDelegate {
    
    func didTapJoltButton(didTap: Bool)
    
    func navigateToTransfersViewController(transfers: [Transfer], transferType: TransferType)
    
    func changePage(page: Int)
}

class DashboardView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var savingsView: SavingsView!
    var debtView: DebtView!
    var assetView: AssetView!
    var pageControl: UIPageControl!
    
    var delegate: DashboardViewDelegate?
    
    var transfers: [Transfer]? {
        didSet {
            if let xfers = transfers {
                savingsView.transfers = xfers
            }
        }
    }
    var userFinMetrics: UserFinMetrics? {
        didSet {
            debtView.userFinMetrics = userFinMetrics
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
        let nib = UINib(nibName: "DashboardView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        savingsView = SavingsView()
        debtView = DebtView()
        assetView = AssetView()
        pageControl = UIPageControl()
                
        scrollView.addSubview(savingsView)
        scrollView.addSubview(debtView)
        scrollView.addSubview(assetView)
        
        savingsView.delegate = self
        debtView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pageWidth = contentView.bounds.width
        let pageHeight = contentView.bounds.height
        
        scrollView.contentSize = CGSize(width: pageWidth * 3, height: pageHeight)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
                
        savingsView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        debtView.frame = CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight)
        assetView.frame = CGRect(x: pageWidth * 2, y: 0, width: pageWidth, height: pageHeight)
    }
}

extension DashboardView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        delegate?.changePage(page: page)
        if page == 1 {
            debtView.firstScrolled = true
        }
    }
}

extension DashboardView: SavingsViewDelegate {
    
    func navigateToTransfersViewController(transfers: [Transfer], transferType: TransferType) {
        delegate?.navigateToTransfersViewController(transfers: transfers, transferType: transferType)
    }

}

extension DashboardView: DebtViewDelegate {
    
    func didTapJoltButton(didTap: Bool) {
        delegate?.didTapJoltButton(didTap: didTap)
    }
    
}
