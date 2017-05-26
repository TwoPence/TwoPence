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

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var penceLabel: UILabel!
    @IBOutlet weak var loginButton: TKTransitionSubmitButton!
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
    
    @IBAction func onLoginTap(_ sender: TKTransitionSubmitButton) {
        sender.animate(1, completion: { () -> () in
            let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TwoPenceTabBarController") as? UITabBarController
            tabViewController?.transitioningDelegate = self
            self.present(tabViewController!, animated: true, completion: nil)
        })
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

}
