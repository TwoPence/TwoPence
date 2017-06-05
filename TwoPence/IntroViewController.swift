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
    var animationView: LOTAnimationView?
    let dataSourceArray = [AppCopy.onboardingScreen1, AppCopy.onboardingScreen2, AppCopy.onboardingScreen3, AppCopy.onboardingScreen4]
    
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
    
    func setAnimationView() {
        animationView = LOTAnimationView(name: "Watermelon")
        guard let animationView = self.animationView else { return }
        animationView.frame = CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: 300)
        animationView.contentMode = .scaleAspectFill
        animationView.isUserInteractionEnabled = false
        view.addSubview(animationView)
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
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: self.view.frame.width * 6, height: 0)
        
        for i in 0...dataSourceArray.count - 1 {
            setAnimationView()
            
            let labelWidth: CGFloat = 300
            let positionX = ((self.scrollView.frame.width - labelWidth) / 2) + CGFloat(i) * self.scrollView.frame.width
            let positionY = self.scrollView.frame.height - 30
            let label = UILabel(frame: CGRect(x: positionX, y: positionY, width: labelWidth, height: 30))
            label.textAlignment = .center
            label.font = UIFont(name: AppFontName.regular, size: 17)
            label.textColor = .black
            label.text = dataSourceArray[i]
            
            if i == 0 {
                logoView = LogoView(frame: CGRect(x: positionX, y: 0, width:237, height: 224))
                logoView?.center = scrollView.center
                scrollView.addSubview(logoView!)
            }
            
            label.isUserInteractionEnabled = false

            scrollView.addSubview(label)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let progress = scrollView.contentOffset.x / scrollView.contentSize.width
        animationView?.animationProgress = progress
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func showLogin(){
        performSegue(withIdentifier: "ShowLoginSegue", sender: nil)
    }
}
