//
//  JoltViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class JoltViewController: UIViewController {
    
    @IBOutlet weak var contentView: JoltView!
    
    var userFinMetrics: UserFinMetrics?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.delegate = self
        
        loadComputationMetrics()
        maybeLoadUserFinMetrics()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadComputationMetrics() {
        TwoPenceAPI.sharedClient.getComputationMetrics(success: { (computationMetrics: ComputationMetrics) in
            self.contentView.computationMetrics = computationMetrics
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func maybeLoadUserFinMetrics() {
        if userFinMetrics == nil {
            TwoPenceAPI.sharedClient.getFinMetrics(success: { (userFinMetrics: UserFinMetrics) in
                self.contentView.userFinMetrics = userFinMetrics
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            contentView.userFinMetrics = userFinMetrics
        }
    }
}

extension JoltViewController: JoltViewDelegate {
    
    func didTapCloseButton(didTap: Bool) {
        if didTap {
            dismiss(animated: true, completion: nil)
        }
    }
}
