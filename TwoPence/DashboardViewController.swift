//
//  DashboardViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var contentView: DashboardView!
    
    var userFinMetrics: UserFinMetrics?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupPageControl()
        loadUserFinMetrics()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPageControl() {
        if let navigationBar = navigationController?.navigationBar {
            let size = navigationBar.bounds.size
            let origin = CGPoint(x: size.width / 2, y: size.height - 4)
            let pageControl = UIPageControl(frame: CGRect(x: origin.x, y: origin.y, width: 0, height: 0))
            pageControl.numberOfPages = 3
            pageControl.tag = 1
            navigationBar.addSubview(pageControl)
            navigationBar.topItem?.title = "Savings"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransactionsDetailViewController && sender != nil {
            let transactionsDetailViewController = segue.destination as! TransactionsDetailViewController
            // Should this transformation go here?
            let transactions = sender as! [Transaction]
            let groupedTransactions = Transaction.groupByDate(transactions: transactions)
            transactionsDetailViewController.groupedTransactions = groupedTransactions
            
        } else if segue.destination is JoltViewController {
            let joltViewController = segue.destination as! JoltViewController
            joltViewController.userFinMetrics = userFinMetrics
        }
    }
    
    func loadUserFinMetrics() {
        TwoPenceAPI.sharedClient.getFinMetrics(success: { (userFinMetrics: UserFinMetrics) in
            self.userFinMetrics = userFinMetrics
            self.contentView.userFinMetrics = userFinMetrics
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
}

extension DashboardViewController: DashboardViewDelegate {
    
    func didTapJoltButton(didTap: Bool) {
        if didTap {
            self.performSegue(withIdentifier: "JoltSegue", sender: nil)
        }
    }

    func navigateToTransactionsDetailViewController(selectedTransactions: [Transaction]) {
        self.performSegue(withIdentifier: "TransactionsSegue", sender: selectedTransactions)
    }
    
    func changePage(page: Int) {
        if let navigationBar = navigationController?.navigationBar {
            let pageControl = navigationBar.viewWithTag(1) as! UIPageControl
            pageControl.currentPage = page
            navigationBar.topItem?.title = getTitleFromPage(page: page)
        }
    }
    
    func getTitleFromPage(page: Int) -> String {
        if page == 0 {
            return "Savings"
        } else if page == 1 {
            return "Debt"
        } else {
            return "Assets"
        }
    }

}
