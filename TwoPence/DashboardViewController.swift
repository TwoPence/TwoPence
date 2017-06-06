
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
    var transfers = [Transfer]()
    var transferType: TransferType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        loadTransfers()
        loadUserFinMetrics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatNavigationBar()
    }
    
    func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            // Add Page Control
            let size = navigationBar.bounds.size
            let origin = CGPoint(x: size.width / 2, y: size.height - 4)
            let pageControl = UIPageControl(frame: CGRect(x: origin.x, y: origin.y, width: 0, height: 0))
            pageControl.numberOfPages = 3
            pageControl.tag = 1
            navigationBar.addSubview(pageControl)
            navigationItem.title = "Savings"
            
            navigationBar.tintColor = AppColor.Charcoal.color
            navigationBar.backIndicatorImage = UIImage(named: "left_chevron")
            navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "left_chevron")
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            navigationBar.barTintColor = UIColor.clear
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            formatNavigationBar()
        }
    }
    
    func formatNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            let pageControl = navigationBar.viewWithTag(1)
            pageControl?.isHidden = false
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : UIFont(name: AppFontName.regular, size: 17)!
            ]
        }
    }

    func loadTransfers() {
        contentView.savingsView.loadingStart()
        TwoPenceAPI.sharedClient.getTransfers(success: { (transfers: [Transfer]) in
            self.contentView.transfers = transfers
            self.contentView.savingsView.loadingEnd()
        }) { (error: Error) in
            print(error.localizedDescription)
            self.contentView.savingsView.loadingEnd()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransfersViewController {
            let transfersViewController = segue.destination as! TransfersViewController
            transfersViewController.transfers = self.transfers
            transfersViewController.transferType = self.transferType
            
        } else if segue.destination is JoltViewController {
            let joltViewController = segue.destination as! JoltViewController
            joltViewController.userFinMetrics = userFinMetrics
        }
    }
}

extension DashboardViewController: DashboardViewDelegate {
    
    func didTapJoltButton(didTap: Bool) {
        if didTap {
            self.performSegue(withIdentifier: "JoltSegue", sender: nil)
        }
    }

    func navigateToTransfersViewController(transfers: [Transfer], transferType: TransferType) {
        self.transfers = transfers
        self.transferType = transferType
        self.performSegue(withIdentifier: "TransfersSegue", sender: nil)
    }
    
    func changePage(page: Int) {
        if let navigationBar = navigationController?.navigationBar {
            let pageControl = navigationBar.viewWithTag(1) as! UIPageControl
            pageControl.currentPage = page
            navigationItem.title = getTitleFromPage(page: page)
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
