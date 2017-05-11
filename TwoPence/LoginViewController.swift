//
//  LoginViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import RevealingSplashView
import Whisper

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "images"),iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0))
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        TwoPenceAPI.sharedClient.getAggTransactions(success: { (aggTransaction) in
            print(aggTransaction.count)
        }) { (error) in
            print((error.localizedDescription))
        }
        
        TwoPenceAPI.sharedClient.getAccounts(success: { (accounts) in
            print(accounts.count)
        }) { (error) in
            // Remove me
            let murmur = Murmur(title: "Network error with login")
            Whisper.show(whistle: murmur, action: .show(0.5))
            print((error.localizedDescription))
        }
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

}
