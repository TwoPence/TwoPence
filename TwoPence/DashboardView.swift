//
//  DashboardView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class DashboardView: UIView, UIScrollViewDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
    }
    
    override func awakeFromNib() {
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: pageWidth * 3, height: pageHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        pageControl.numberOfPages = 3
        
        // Replace these with xibs.
        let savingsView = UIView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        savingsView.backgroundColor = UIColor.blue
        let debtView = UIView(frame: CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight))
        debtView.backgroundColor = UIColor.red
        let assetView = UIView(frame: CGRect(x: pageWidth * 2, y: 0, width: pageWidth, height: pageHeight))
        assetView.backgroundColor = UIColor.green
        
        scrollView.addSubview(savingsView)
        scrollView.addSubview(debtView)
        scrollView.addSubview(assetView)
    }
    
    @IBAction func pageControlDidPage(_ sender: Any) {
        let xOffset = scrollView.bounds.width * CGFloat(pageControl.currentPage)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
