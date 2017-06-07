//
//  IntroViewController.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/29/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Lottie
import IBAnimatable

class IntroViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sigupButton: UIButton!
    @IBOutlet weak var signinButton: TKTransitionSubmitButton!
    
    var logoView: LogoView?
    let callArray = ["", AppCopy.onboardingCall1, AppCopy.onboardingCall2, AppCopy.onboardingCall3]
    let responseArray = ["Swipe to learn more", AppCopy.onboardingResponse1, AppCopy.onboardingResponse2, AppCopy.onboardingResponse3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "logo"),iconInitialSize: CGSize(width: 119, height: 134), backgroundColor: AppColor.PaleGreen.color)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        performSegue(withIdentifier: "ShowLoginSegue", sender: nil)
    }
    
    @IBAction func onSignin(_ sender: Any) {
        performSegue(withIdentifier: "ShowLoginSegue", sender: nil)
    }
    
    func setUpScrollView() {
        let pages: Int = 4
        let pageWidth = self.view.bounds.width
        let pageHeight = scrollView.bounds.height
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(pages), height: pageHeight)
        
        // Ending Logo.
        let positionX = 3.5 * self.view.bounds.width
        let positionY = scrollView.bounds.height / 2
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        logoImageView.center = CGPoint(x: positionX, y: positionY)
        logoImageView.alpha = 1.0
        logoImageView.tag = 4
        scrollView.addSubview(logoImageView)

        for page in 0..<pages {
            // Text.
            let textHeight: CGFloat = 80.0
            let textInset: CGFloat = 16.0
            let font = UIFont(name: AppFontName.bold, size: 17)
            
            // Call Label.
            let callLabelHeight: CGFloat = 20
            let callLabelFrame = CGRect(x: CGFloat(page) * pageWidth + textInset, y: pageHeight - textHeight, width: (pageWidth - textInset * 2), height: callLabelHeight)
            let callLabel = UILabel(frame: callLabelFrame)
            callLabel.textAlignment = .center
            callLabel.font = font
            callLabel.textColor = AppColor.DarkSeaGreen.color
            callLabel.numberOfLines = 1
            callLabel.text = callArray[page]
            scrollView.addSubview(callLabel)
            
            // Response Label.
            let responseFrame = CGRect(x: CGFloat(page) * pageWidth + textInset, y: pageHeight - textHeight + callLabelHeight, width: (pageWidth - textInset * 2), height: textHeight - callLabelHeight)
            let responseLabel = UILabel(frame: responseFrame)
            responseLabel.textAlignment = .center
            responseLabel.font = page == 0 ? font : font?.withSize(15)
            responseLabel.textColor = AppColor.Charcoal.color
            responseLabel.numberOfLines = 3
            responseLabel.text = responseArray[page]
            scrollView.addSubview(responseLabel)
            
            if page == 0 {
                // Logo.
                let logoFrame = CGRect(x: 0, y: 0, width: 237, height: 224)
                logoView = LogoView(frame: logoFrame)
                logoView?.center = scrollView.center
                if let _logoView = logoView {
                    scrollView.addSubview(_logoView)
                }
            } else {
                // Animation.
                let animationHeight = pageHeight - textHeight
                let animationFrame = CGRect(x: CGFloat(page) * pageWidth, y: 0, width: pageWidth, height: animationHeight)
                let animation = "segment\(page)"
                print("\(animation)")
                if let animationView = LOTAnimationView(name: animation) {
                    animationView.frame = animationFrame
                    animationView.contentMode = .scaleAspectFill
                    animationView.clipsToBounds = true
                    animationView.animationSpeed = page == 3 ? 1.5 : 1.0
                    animationView.tag = page
                    scrollView.addSubview(animationView)
                }
            }
        }
    }
    
    func formatDisplay(){
        sigupButton.backgroundColor = AppColor.DarkSeaGreen.color
        sigupButton.layer.cornerRadius = 4
        sigupButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        sigupButton.setTitleColor(UIColor.white, for: .normal)
        
        sigupButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
        sigupButton.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
        sigupButton.layer.borderWidth = 1
        
        signinButton.backgroundColor = UIColor.white
        signinButton.layer.cornerRadius = 4
        signinButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        signinButton.setTitleColor(AppColor.DarkSeaGreen.color, for: .normal)
        
        signinButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
        signinButton.layer.borderColor = AppColor.DarkSeaGreen.color.cgColor
        signinButton.layer.borderWidth = 1
    }
    
    func animateLogo(){
        logoView?.twoPenceLogo.delay(1.2)
            .then(.squeezeFade(way: .in, direction: .down))
    }
}

extension IntroViewController: UIScrollViewDelegate {

   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let logoView = scrollView.viewWithTag(4) as! UIImageView
        logoView.alpha = 0.0
        scrollView.bringSubview(toFront: logoView)
        let pageNumber = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = pageNumber
        if pageNumber != 0 {
            let animationView = scrollView.viewWithTag(pageNumber) as! LOTAnimationView
            animationView.play(completion: { (_) in
                if pageNumber == 3 {
                    UIView.animate(withDuration: 0.5, animations: {
                        logoView.alpha = 1.0
                    })
                }
            })
        }
    }
    
    func showLogin(){
        performSegue(withIdentifier: "ShowLoginSegue", sender: nil)
    }
}
