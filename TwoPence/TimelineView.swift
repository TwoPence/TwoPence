//
//  TimelineView.swift
//  Evan Dekhayser
//
//  Created by Evan Dekhayser on 7/25/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit
import AVFoundation

/**
	Represents an instance in the Timeline. A Timeline is built using one or more of these TimeFrames.
 */
public struct TimeFrame{
    /**
     A description of the event.
     */
    let text: String
    /**
     The date that the event occured.
     */
    let date: String
    
    let debtMilestone: DebtMilestone
    
    let debtMilestonePosition: Int
    
    /**
     An optional image to show with the text and the date in the timeline.
     */
    let image: UIImage?
}

/**
	The shape of a bullet that appears next to each event in the Timeline.
 */
public enum BulletType{
    /**
     Bullet shaped as a circle with no fill.
     */
    case circle
    /**
     Bullet shaped as a hexagon with no fill.
     */
    case hexagon
    /**
     Bullet shaped as a diamond with no fill.
     */
    case diamond
    /**
     Bullet shaped as a circle with no fill and a horizontal line connecting two vertices.
     */
    case diamondSlash
    /**
     Bullet shaped as a carrot facing inward toward the event.
     */
    case carrot
    /**
     Bullet shaped as an arrow pointing inward toward the event.
     */
    case arrow
}

/**
	View that shows the given events in bullet form.
 */
open class TimelineView: UIView {
    
    var currentMilestoneView: UIView?
    
    open var onTap:  ((AnyObject, UIEvent) -> ())?
    
    //MARK: Public Properties
    
    /**
     The events shown in the Timeline
     */
    open var timeFrames: [TimeFrame]{
        didSet{
            setupContent()
        }
    }
    
    /**
     The color of the bullets and the lines connecting them.
     */
    open var lineColor: UIColor = UIColor.lightGray{
        didSet{
            setupContent()
        }
    }
    
    /**
     Color of the larger Date title label in each event.
     */
    open var titleLabelColor: UIColor = AppColor.Charcoal.color {
        didSet{
            setupContent()
        }
    }
    
    /**
     Color of the smaller Text detail label in each event.
     */
    open var detailLabelColor: UIColor = AppColor.MediumGray.color{
        didSet{
            setupContent()
        }
    }
    
    /**
     The type of bullet shown next to each element.
     */
    open var bulletType: BulletType = BulletType.diamond{
        didSet{
            setupContent()
        }
    }
    
    /**
     If enabled, the timeline shows with the bullet on the right side instead of the left.
     */
    open var showBulletOnRight: Bool = false{
        didSet{
            setupContent()
        }
    }
    
    //MARK: Public Methods
    
    /**
     Note that the timeFrames cannot be set by this method. Further setup is required once this initalization occurs.
     
     May require more work to allow this to work with restoration.
     
     @param coder An unarchiver object.
     */
    required public init?(coder aDecoder: NSCoder) {
        timeFrames = []
        super.init(coder: aDecoder)
    }
    
    /**
     Initializes the timeline with all information needed for a complete setup.
     
     @param bulletType The type of bullet shown next to each element.
     
     @param timeFrames The events shown in the Timeline
     */
    public init(bulletType: BulletType, timeFrames: [TimeFrame], onTap: @escaping (AnyObject, UIEvent) -> ()){
        self.timeFrames = timeFrames
        self.bulletType = bulletType
        self.onTap = onTap
        super.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false
        
        setupContent()
    }
    
    //MARK: Private Methods
    
    fileprivate func setupContent(){
        for v in subviews{
            v.removeFromSuperview()
        }
        
        let guideView = UIView()
        guideView.isUserInteractionEnabled = true
        guideView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(guideView)
        addConstraints([
            NSLayoutConstraint(item: guideView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: guideView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: guideView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: guideView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
            ])
        
        var i = 0
        
        var viewFromAbove = guideView
        
        for element in timeFrames{
            let v = blockForTimeFrame(element, imageTag: i)
            addSubview(v)
            
            addConstraints([
                NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: viewFromAbove, attribute: .bottom, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: v, attribute: .width, relatedBy: .equal, toItem: viewFromAbove, attribute: .width, multiplier: 1.0, constant: 0),
                ])
            if showBulletOnRight{
                addConstraint(NSLayoutConstraint(item: v, attribute: .right, relatedBy: .equal, toItem: viewFromAbove, attribute: .right, multiplier: 1.0, constant: 0))
            } else {
                addConstraint(NSLayoutConstraint(item: v, attribute: .left, relatedBy: .equal, toItem: viewFromAbove, attribute: .left, multiplier: 1.0, constant: 0))
            }
            viewFromAbove = v
            
            i += 1
        }
        
        let extraSpace: CGFloat = 200
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = lineColor
        addSubview(line)
        sendSubview(toBack: line)
        addConstraints([
            NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1),
            NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: viewFromAbove, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: extraSpace)
            ])
        if showBulletOnRight{
            addConstraint(NSLayoutConstraint(item: line, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -16.5))
        } else {
            addConstraint(NSLayoutConstraint(item: line, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 16.5))
        }
        addConstraint(NSLayoutConstraint(item: viewFromAbove, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
    
    fileprivate func bulletView(_ size: CGSize, bulletType: BulletType, color: UIColor, stColor: UIColor) -> UIView {
        var path: UIBezierPath
        switch bulletType {
        case .circle:
            path = UIBezierPath(ovalOfSize: size)
        case .diamond:
            path = UIBezierPath(diamondOfSize: size)
        case .diamondSlash:
            path = UIBezierPath(diamondSlashOfSize: size)
        case .hexagon:
            path = UIBezierPath(hexagonOfSize: size)
        case .carrot:
            path = UIBezierPath(carrotOfSize: size)
        case .arrow:
            path = UIBezierPath(arrowOfSize: size)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = stColor.cgColor
        //shapeLayer.fillColor = UIColor.clear.cgColor
        //shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.path = path.cgPath
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.width))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.addSublayer(shapeLayer)
        return v
    }
    
    fileprivate func blockForTimeFrame(_ element: TimeFrame, imageTag: Int) -> UIView{
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        //bullet
        let s = CGSize(width: 14, height: 14)
        var bullet: UIView = bulletView(s, bulletType: bulletType, color: UIColor.green, stColor: UIColor.green)
        if(element.debtMilestone.type == MilestoneType.Complete){
            // All green
            bullet = bulletView(s, bulletType: bulletType, color: AppColor.DarkSeaGreen.color, stColor: AppColor.DarkSeaGreen.color)
        } else if(element.debtMilestone.type == MilestoneType.Current){
            // outside green, inside clear
            currentMilestoneView = v
            bullet = bulletView(s, bulletType: bulletType, color: UIColor.clear, stColor: AppColor.DarkSeaGreen.color)
        } else {
            // outside grey, inside clear
            bullet = bulletView(s, bulletType: bulletType, color: UIColor.clear, stColor: AppColor.MediumGray.color)
        }
        
        v.addSubview(bullet)
        v.addConstraint(NSLayoutConstraint(item: bullet, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1.0, constant: 0))
        if showBulletOnRight{
            v.addConstraint(NSLayoutConstraint(item: bullet, attribute: .right, relatedBy: .equal, toItem: v, attribute: .right, multiplier: 1.0, constant: -24))
        } else {
            v.addConstraint(NSLayoutConstraint(item: bullet, attribute: .left, relatedBy: .equal, toItem: v, attribute: .left, multiplier: 1.0, constant: 10))
        }
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: AppFontName.regular, size: 17)
        // Set Future milestone title to Gray to reflect disabled.
        if element.debtMilestone.type == .Future {
            titleLabel.textColor = AppColor.MediumGray.color
        } else {
            titleLabel.textColor = titleLabelColor
        }
        titleLabel.text = element.date
        titleLabel.numberOfLines = 0
        titleLabel.layer.masksToBounds = false
        v.addSubview(titleLabel)
        v.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: v, attribute: .width, multiplier: 1.0, constant: -40),
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1.0, constant: -5)
            ])
        if showBulletOnRight{
            v.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: v, attribute: .right, multiplier: 1.0, constant: -40))
            titleLabel.textAlignment = .right
        } else {
            v.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: v, attribute: .left, multiplier: 1.0, constant: 40))
            titleLabel.textAlignment = .left
        }
        
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: AppFontName.regular, size: 13)
        textLabel.text = element.text
        textLabel.textColor = detailLabelColor
        textLabel.numberOfLines = 0
        textLabel.layer.masksToBounds = false
        v.addSubview(textLabel)
        v.addConstraints([
            NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: v, attribute: .width, multiplier: 1.0, constant: -40),
            NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 1),
            ])
        if showBulletOnRight{
            v.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal, toItem: v, attribute: .right, multiplier: 1.0, constant: -40))
            textLabel.textAlignment = .right
        } else {
            v.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: v, attribute: .left, multiplier: 1.0, constant: 40))
            textLabel.textAlignment = .left
        }
        
        //image
        if let image = element.image{
            
            let backgroundViewForImage = UIView()
            backgroundViewForImage.translatesAutoresizingMaskIntoConstraints = false
            if element.debtMilestone.type == .Complete {
                backgroundViewForImage.backgroundColor = AppColor.MediumGreen.color
            } else {
                backgroundViewForImage.backgroundColor = AppColor.PaleGray.color
            }
            backgroundViewForImage.layer.cornerRadius = 4
            v.addSubview(backgroundViewForImage)
            v.addConstraints([
                NSLayoutConstraint(item: backgroundViewForImage, attribute: .width, relatedBy: .equal, toItem: v, attribute: .width, multiplier: 1.0, constant: -60),
                NSLayoutConstraint(item: backgroundViewForImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150),
                NSLayoutConstraint(item: backgroundViewForImage, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: backgroundViewForImage, attribute: .bottom, relatedBy: .equal, toItem: v, attribute: .bottom, multiplier: 1.0, constant: -10)
                ])
            if showBulletOnRight{
                v.addConstraint(NSLayoutConstraint(item: backgroundViewForImage, attribute: .right, relatedBy: .equal, toItem: v, attribute: .right, multiplier: 1.0, constant: -40))
            } else {
                v.addConstraint(NSLayoutConstraint(item: backgroundViewForImage, attribute: .left, relatedBy: .equal, toItem: v, attribute: .left, multiplier: 1.0, constant: 40))
            }
            
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = 4
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = UIViewContentMode.scaleAspectFit

            v.addSubview(imageView)
            imageView.tag = imageTag

            v.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: backgroundViewForImage, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
            
            v.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: backgroundViewForImage, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: 20.0))
            v.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: backgroundViewForImage, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 20.0))
            v.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 100.0))

            let button = UIButton(type: .custom)
            button.tag = element.debtMilestonePosition
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor.clear
            button.tag = imageTag
            button.addTarget(self, action:#selector(handleRegister(button:forEvent:)), for: .touchUpInside)
            
            v.addSubview(button)
            v.addConstraints([
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: v, attribute: .width, multiplier: 1.0, constant: -60),
                NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 170),
                NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1.0, constant: 0)
                ])
            if showBulletOnRight{
                v.addConstraint(NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: v, attribute: .right, multiplier: 1.0, constant: -40))
            } else {
                v.addConstraint(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: v, attribute: .left, multiplier: 1.0, constant: 40))
            }
        } else {
            v.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: v, attribute: .bottom, multiplier: 1.0, constant: -10))
        }
        
        //draw the line between the bullets
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        if (element.debtMilestone.type == MilestoneType.Complete){
            line.backgroundColor = AppColor.DarkSeaGreen.color
        } else {
            line.backgroundColor = AppColor.MediumGray.color
        }
        
        v.addSubview(line)
        sendSubview(toBack: line)
        v.addConstraints([
            NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1),
            NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1.0, constant: 14),
            NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: v, attribute: .height, multiplier: 1.0, constant: 2)
            ])
        if showBulletOnRight{
            v.addConstraint(NSLayoutConstraint(item: line, attribute: .right, relatedBy: .equal, toItem: v, attribute: .right, multiplier: 1.0, constant: -16.5))
        } else {
            v.addConstraint(NSLayoutConstraint(item: line, attribute: .left, relatedBy: .equal, toItem: v, attribute: .left, multiplier: 1.0, constant: 16.5))
        }
        
        return v
    }
    
    
    @objc fileprivate func handleRegister(button: UIButton, forEvent event: UIEvent){
        onTap!(button, event)
    }
}

extension UIBezierPath {
    
    convenience init(hexagonOfSize size: CGSize) {
        self.init()
        move(to: CGPoint(x: size.width / 2, y: 0))
        addLine(to: CGPoint(x: size.width, y: size.height / 3))
        addLine(to: CGPoint(x: size.width, y: size.height * 2 / 3))
        addLine(to: CGPoint(x: size.width / 2, y: size.height))
        addLine(to: CGPoint(x: 0, y: size.height * 2 / 3))
        addLine(to: CGPoint(x: 0, y: size.height / 3))
        close()
    }
    
    convenience init(diamondOfSize size: CGSize) {
        self.init()
        move(to: CGPoint(x: size.width / 2, y: 0))
        addLine(to: CGPoint(x: size.width, y: size.height / 2))
        addLine(to: CGPoint(x: size.width / 2, y: size.height))
        addLine(to: CGPoint(x: 0, y: size.width / 2))
        close()
    }
    
    convenience init(diamondSlashOfSize size: CGSize) {
        self.init(diamondOfSize: size)
        move(to: CGPoint(x: 0, y: size.height/2))
        addLine(to: CGPoint(x: size.width, y: size.height / 2))
    }
    
    convenience init(ovalOfSize size: CGSize) {
        self.init(ovalIn: CGRect(origin: CGPoint.zero, size: size))
    }
    
    convenience init(carrotOfSize size: CGSize) {
        self.init()
        move(to: CGPoint(x: size.width/2, y: 0))
        addLine(to: CGPoint(x: size.width, y: size.height / 2))
        addLine(to: CGPoint(x: size.width / 2, y: size.height))
    }
    
    convenience init(arrowOfSize size: CGSize) {
        self.init(carrotOfSize: size)
        move(to: CGPoint(x: 0, y: size.height/2))
        addLine(to: CGPoint(x: size.width, y: size.height / 2))
    }
}
