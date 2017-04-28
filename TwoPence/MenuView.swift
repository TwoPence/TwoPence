//
//  MenuView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/27/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

@objc protocol MenuViewDelegate {
    
    @objc optional func passActiveViewController(activeViewController: UIViewController)
}

class MenuView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewControllers: [(title: String, viewController: UIViewController)]!
    weak var delegate: MenuViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "MenuView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func awakeFromNib() {
        let menuItemCell = UINib(nibName: "MenuItemCell", bundle: nil)
        tableView.register(menuItemCell, forCellReuseIdentifier: "MenuItemCell")
        let menuUserCell = UINib(nibName: "MenuUserCell", bundle: nil)
        tableView.register(menuUserCell, forCellReuseIdentifier: "MenuUserCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuUserCell", for: indexPath) as! MenuUserCell
            // cell.userGravatarImageView.image =
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
            cell.menuItemLabel.text = viewControllers[indexPath.row].title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.passActiveViewController(activeViewController: viewControllers[indexPath.row].viewController)
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
