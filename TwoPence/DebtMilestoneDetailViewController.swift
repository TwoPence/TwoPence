//
//  DebtMilestoneDetailViewController.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/4/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class DebtMilestoneDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func closeMilestoneDetail(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }

}
