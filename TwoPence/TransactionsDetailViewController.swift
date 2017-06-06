//
//  TransactionsDetailViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Whisper

class TransactionsDetailViewController: UIViewController {

    @IBOutlet weak var contentView: TransactionsView!
    
    var transactions: [Transaction]?
    var groupedTransactions: [(date: Date, transactions: [Transaction])]?
    var isPending: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        
        if let groupedTrans = groupedTransactions  {
            contentView.groupedTransactions = groupedTrans
        }
        updateNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func updateNavigationBar() {
        navigationItem.title = isPending ? "Pending" : "Cleared"
        self.navigationController?.navigationBar.tintColor = AppColor.Charcoal.color
        if let navigationBar = navigationController?.navigationBar {
            let pageControl = navigationBar.viewWithTag(1) as! UIPageControl
            pageControl.isHidden = true
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : AppColor.Charcoal.color,
                NSFontAttributeName : UIFont(name: AppFontName.regular, size: 17)!
            ]
        }
    }
}

extension TransactionsDetailViewController: TransactionsViewDelegate {
    
    func didSkipTransaction(amountSkipped: Double) {
        let title = amountSkipped.money() + " removed from your savings"
        let message = Message(title: title, textColor: UIColor.white, backgroundColor: AppColor.DarkSeaGreen.color, images: nil)
        Whisper.show(whisper: message, to: self.navigationController!, action: .show)
    }
}
