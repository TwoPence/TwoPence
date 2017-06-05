//
//  AddSponsorDetailViewController.swift
//  TwoPence
//
//  Created by Will Gilman on 5/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class AddSponsorDetailViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstNameBorderView: UIView!
    @IBOutlet weak var lastNameBorderView: UIView!
    @IBOutlet weak var emailBorderView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var messageTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var relationTextField: UITextField!
    @IBOutlet weak var relationBorderView: UIView!
    @IBOutlet weak var relationTableView: UITableView!
    @IBOutlet weak var relationTableViewHeightConstraint: NSLayoutConstraint!
    
    var contact: CNContact!
    var relations: [String] = ["Family", "Friend", "Employer"]
    var messageExpandedConstraint: CGFloat = -180
    var messageCollapsedConstraint: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorView.backgroundColor = AppColor.Blue.color
        setupNavigationBar()
        setupDisplay()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 32.0
        tableView.isHidden = true
        
        relationTableView.delegate = self
        relationTableView.dataSource = self
        relationTableView.rowHeight = 32.0
        relationTableView.isHidden = true
        
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldActive), for: .touchDown)
        
        relationTextField.delegate = self
        relationTextField.addTarget(self, action: #selector(relationTextFieldActive), for: .touchDown)
        
        messageTextView.delegate = self
        messageTextView.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        relationTableViewHeightConstraint.constant = relationTableView.contentSize.height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch:UITouch = touches.first else {
            return
        }
        if touch.view != tableView {
            emailTextField.endEditing(true)
            tableView.isHidden = true
        }
        if touch.view != relationTableView {
            relationTextField.endEditing(true)
            relationTableView.isHidden = true
        }
        if touch.view != messageTextView && messageTextViewIsActive() {
            collapseMessageTextView()
        }
    }
    
    @IBAction func emailTextFieldChanged(_ sender: Any) {
        tableView.isHidden = true
    }
    
    @IBAction func relationTextFieldChanged(_ sender: Any) {
        relationTableView.isHidden = true
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Link a Sponsor"
        let closeBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(cancel))
        closeBtn.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = closeBtn
    }
    
    func setupDisplay() {
        let font = UIFont(name: AppFontName.regular, size: 17)
        let color = AppColor.Charcoal.color
        titleLabel.textColor = color
        titleLabel.font = font

        firstNameTextField.textColor = color
        firstNameTextField.font = font?.withSize(15)
        firstNameTextField.placeholder = "First Name"
        
        lastNameTextField.textColor = color
        lastNameTextField.font = font?.withSize(15)
        lastNameTextField.placeholder = "Last Name"
        
        emailTextField.textColor = color
        emailTextField.font = font?.withSize(15)
        emailTextField.placeholder = "Select or Input Email Address"
        
        relationTextField.textColor = color
        relationTextField.font = font?.withSize(15)
        relationTextField.placeholder = "Relationship to You"

        firstNameTextField.text = contact.givenName
        lastNameTextField.text = contact.familyName
        emailTextField.text = nil
        relationTextField.text = nil
        
        firstNameBorderView.backgroundColor = AppColor.PaleGray.color
        lastNameBorderView.backgroundColor = AppColor.PaleGray.color
        emailBorderView.backgroundColor = AppColor.PaleGray.color
        relationBorderView.backgroundColor = AppColor.PaleGray.color
        
        messageTextView.font = font?.withSize(15)
        messageTextView.textColor = color
        messageTextView.layer.borderColor = AppColor.PaleGray.color.cgColor
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.cornerRadius = 8.0
        messageTextView.text = AppCopy.linkSponsorMessage
        
        linkButton.backgroundColor = AppColor.DarkSeaGreen.color
        linkButton.layer.cornerRadius = 4.0
        linkButton.setTitleColor(UIColor.white, for: .normal)
        linkButton.titleLabel?.font = font?.withSize(17)
    }
    
    func textFieldActive() {
        tableView.isHidden = !tableView.isHidden
        view.bringSubview(toFront: tableView)
    }
    
    func relationTextFieldActive() {
        relationTextField.resignFirstResponder()
        relationTableView.isHidden = !relationTableView.isHidden
        view.bringSubview(toFront: relationTableView)
    }
    
    func messageTextViewIsActive() -> Bool {
        return messageTextViewTopConstraint.constant == messageExpandedConstraint
    }
    
    func collapseMessageTextView () {
        messageTextViewTopConstraint.constant = messageCollapsedConstraint
        if messageTextView.text.isEmpty {
            messageTextView.text = AppCopy.linkSponsorMessage
        }
        messageTextView.resignFirstResponder()
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapLinkButton(_ sender: Any) {
        if emailTextField.text == "" {
            emailBorderView.backgroundColor = AppColor.Red.color
            emailTextField.placeholder = "A valid email is required"
        } else {
            confirmInvitation()
        }
    }
    
    func confirmInvitation() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let margin: CGFloat = 8.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.width - margin * 2, height: 120)
        let customView = UIView(frame: rect)
        
        let label = UILabel(frame: CGRect(x: customView.center.x, y: customView.center.y, width: customView.frame.width, height: customView.frame.height/3))
        label.text = "TwoPence will send an sponsor invitation to \(emailTextField.text!)"
        label.center = customView.center
        label.center.x = customView.center.x
        label.center.y = customView.center.y
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        customView.addSubview(label)
        alertController.view.addSubview(customView)
        
        let somethingAction = UIAlertAction(title: "Confirm", style: .default, handler: {(alert: UIAlertAction!) in
            self.cancel()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
            self.cancel()
        })

        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        topVC?.present(alertController, animated: true, completion: nil)
    }
}

extension AddSponsorDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Don't allow editing for the Relation field.
        if textField == self.relationTextField {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        relationTextField.resignFirstResponder()
        return true
    }
}

extension AddSponsorDetailViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        messageTextViewTopConstraint.constant = messageExpandedConstraint
        if textView.text == AppCopy.linkSponsorMessage {
            messageTextView.text = ""
        }
        view.bringSubview(toFront: messageTextView)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        collapseMessageTextView()
    }
}

extension AddSponsorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if tableView == self.tableView {
            count = contact.emailAddresses.count
        }
        if tableView == self.relationTableView {
            count = relations.count
        }
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.separatorInset = .zero
        cell.textLabel?.textColor = AppColor.Charcoal.color
        cell.textLabel?.font = UIFont(name: AppFontName.regular, size: 15)
        cell.textLabel?.textAlignment = .left
        if tableView == self.tableView {
            cell.textLabel?.text = contact.emailAddresses[indexPath.row].value as String
        }
        if tableView == self.relationTableView {
            cell.textLabel?.text = relations[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.tableView {
            emailTextField.text = contact.emailAddresses[indexPath.row].value as String
            emailBorderView.backgroundColor = AppColor.PaleGray.color
            tableView.isHidden = true
            emailTextField.endEditing(true)
        }
        if tableView == self.relationTableView {
            relationTextField.text = relations[indexPath.row]
            relationTableView.isHidden = true
            relationTextField.endEditing(true)
        }
    }
}
