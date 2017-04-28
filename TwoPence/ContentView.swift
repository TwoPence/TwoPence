//
//  ContentView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/27/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

class ContentView: UIView, MenuViewDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var contentViewPanStartPoint: CGPoint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "ContentView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func awakeFromNib() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanContentView(_:)))
        contentView.addGestureRecognizer(panGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    @IBAction func onPanContentView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        let velocity = sender.velocity(in: self)
        let minXOffset = self.bounds.width / 2
        let maxXOffset = self.bounds.width + (contentView.bounds.width / 2) - 40
        switch sender.state {
        case .began:
            contentViewPanStartPoint = contentView.center
            break
        case .changed:
            let start = contentViewPanStartPoint!
            contentView.center = CGPoint(
                x: min(max(minXOffset, start.x + translation.x), maxXOffset),
                y: start.y)
            break
        case .ended:
            if (velocity.x > 0) {
                showMenu()
            } else {
                hideMenu()
            }
            break
        case .cancelled:
            break
        default:
            break
        }
    }
    
    func showMenu(){
        let maxXOffset = self.bounds.width + (contentView.bounds.width / 2) - 40
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.center.x = maxXOffset
        })
    }
    
    func hideMenu(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.frame.origin.x = 0
        })
    }
    
    func didSelectMenuItem(didSelect: Bool) {
        if didSelect {
            hideMenu()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
