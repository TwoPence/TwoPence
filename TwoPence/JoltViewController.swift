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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Jolt"
        let closeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(JoltViewController.closeJoltModal))
        closeBtn.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = closeBtn
        if let navigationBar = navigationController?.navigationBar{
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : UIFont(name: "Lato-Regular", size: 17)!
            ]
            navigationBar.barTintColor = UIColor.clear
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // This is a hack to force the display to update after the view loads.
        contentView.joltAmount = 20
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
    
    func closeJoltModal() {
        dismiss(animated: true, completion: nil)
    }
}

extension JoltViewController: JoltViewDelegate {
    
    func didCompleteJolt(completed: Bool) {
        if completed {
            dismiss(animated: true, completion: nil)
        }
    }
}
