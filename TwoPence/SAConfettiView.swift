//
//  SAConfettiView.swift
//
//  Created by Sudeep Agarwal on 12/14/15.
//
//

import UIKit
import QuartzCore

open class SAConfettiView: UIView {
    
    public enum ConfettiType {
        case confetti
        case triangle
        case star
        case diamond
        case image(UIImage)
    }
    
    var emitter: CAEmitterLayer!
    open var colors: [UIColor]!
    open var intensity: Float!
    open var type: ConfettiType!
    fileprivate var active :Bool!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        colors = [AppColor.DarkSeaGreen.color,
                  AppColor.MediumGreen.color,
                  AppColor.Cream.color,
                  AppColor.Blue.color]
        intensity = 0.5
        type = .confetti
        active = false
        isUserInteractionEnabled = false
    }
    
    open func startConfetti() {
        emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color))
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }
    
    open func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }
    
    func imageForType(_ type: ConfettiType) -> UIImage? {
        
        /*
        var fileName: String!
        
        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case let .image(customImage):
            return customImage
        }
         */
        
        return #imageLiteral(resourceName: "confetti.png")
    }
    
    func confettiWithColor(_ color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = .pi
        confetti.emissionRange = .pi/4
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = imageForType(type)!.cgImage
        return confetti
    }
    
    open func isActive() -> Bool {
        return self.active
    }
}
