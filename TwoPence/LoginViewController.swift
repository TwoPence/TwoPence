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

    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var penceLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "logo"),iconInitialSize: CGSize(width: 120, height: 130), backgroundColor: AppColor.MediumGreen.color)
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)

        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        formatDisplay()
    }
    
    func formatDisplay() {
        twoLabel.textColor = AppColor.DarkSeaGreen.color
        penceLabel.textColor = UIColor.white
        
        signUpButton.backgroundColor = UIColor.white
        signUpButton.layer.cornerRadius = 4
        signUpButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        signUpButton.titleLabel?.textColor = UIColor.red
        signUpButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
        
        loginButton.backgroundColor = UIColor.clear
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.titleLabel?.textColor = UIColor.white
        loginButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
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
