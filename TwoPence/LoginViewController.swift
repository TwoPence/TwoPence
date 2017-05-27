//
//  LoginViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 4/26/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Whisper
import IBAnimatable

class LoginViewController: UIViewController {

    @IBOutlet weak var twoLabel: AnimatableLabel!
    @IBOutlet weak var penceLabel: AnimatableLabel!
    @IBOutlet weak var loginButton: TKTransitionSubmitButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var twopenceLogo: AnimatableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.twoLabel.isHidden = true
        self.penceLabel.isHidden = true
        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "logo"),iconInitialSize: CGSize(width: 119, height: 134), backgroundColor: AppColor.MediumGreen.color)
        revealingSplashView.animationType = .down
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)

        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        formatDisplay()
        animateLogo()
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
}


extension LoginViewController: UIViewControllerTransitioningDelegate {
    func animateLogo(){
        twopenceLogo.delay(1.2)
            .then(.squeezeFade(way: .in, direction: .down))
            .completion {
                self.twoLabel.isHidden = false
                self.penceLabel.isHidden = false
                self.twoLabel.delay(0)
                    .then(.squeezeFade(way: .in, direction: .left))
                self.penceLabel.delay(0)
                    .then(.squeezeFade(way: .in, direction: .right))
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
