//
//  JoltSuccessView.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/16/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class JoltSuccessView: UIViewController {
    
    @IBOutlet weak var successTextLabel: UILabel!
    var successMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.DarkSeaGreen.color
        successTextLabel.textColor = UIColor.white
        successTextLabel.font = UIFont(name: AppFontName.regular, size: 17)
        successTextLabel.text = successMessage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
