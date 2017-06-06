//
//  TransfersViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 5/24/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class TransfersViewController: UIViewController {

    @IBOutlet weak var contentView: TransfersView!
    
    var transfers: [Transfer]?
    var transferType: TransferType?
    var groupedTransactions: [(date: Date, transactions: [Transaction])]?
    var isPending: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        
        if let xfers = transfers { contentView.transfers = xfers }
        if let type = transferType { contentView.transferType = type }
        updateNavigationBar(title: transferType?.text ?? "Transfers")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func updateNavigationBar(title: String) {
        navigationItem.title = title
        self.navigationController?.navigationBar.tintColor = AppColor.Charcoal.color
        if let navigationBar = navigationController?.navigationBar {
            let pageControl = navigationBar.viewWithTag(1) as! UIPageControl
            pageControl.isHidden = true
            navigationBar.backIndicatorImage = UIImage(named: "left_chevron")
            navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "left_chevron")
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : AppColor.Charcoal.color,
                NSFontAttributeName : UIFont(name: AppFontName.regular, size: 17)!
            ]
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TransactionsDetailViewController {
            let transactionsDetailViewController = segue.destination as! TransactionsDetailViewController
            transactionsDetailViewController.groupedTransactions = self.groupedTransactions
            transactionsDetailViewController.isPending = self.isPending
        }
    }
}

extension TransfersViewController: TransfersViewDelegate {
    
    func navigateToTransactionsDetailViewController(selectedTransactions: [(date: Date, transactions: [Transaction])], isPending: Bool) {
        self.groupedTransactions = selectedTransactions
        self.isPending = isPending
        self.performSegue(withIdentifier: "TransactionsSegue", sender: nil)
    }
    
    func initiateTransferType(transferType: TransferType) {
        switch transferType {
        case .Jolt:
            print("Launch Jolt VC")
            // self.performSegue(withIdentifier: "JoltSegue", sender: nil)
        case .Sponsor:
            print("Launch Sponsor VC")
            self.performSegue(withIdentifier: "AddSponsorSegue", sender: nil)
        default:
            break
        }
    }
}
