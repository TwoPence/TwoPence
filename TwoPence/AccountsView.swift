//
//  AccountsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/30/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit

@objc protocol AccountsViewDelegate {
    
    @objc optional func navigateToAccountsDetailViewController(selectedInstitution: Institution)
}

class AccountsView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var institutions: [Institution] = []
    weak var delegate: AccountsViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "AccountsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override func awakeFromNib() {
        initFakeAccounts() // REMOVE: Testing only
        let cell = UINib(nibName: "InstitutionCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "InstitutionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return institutions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstitutionCell", for: indexPath) as! InstitutionCell
        cell.institution = institutions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.navigateToAccountsDetailViewController?(selectedInstitution: institutions[indexPath.row])
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // REMOVE: --------- Testing only ---------
    private func initFakeAccounts() {
        let bankAccounts = [
            Account(name: "Checking", value: 1238.11, type: "Depository"),
            Account(name: "Savings", value: 3745.85, type: "Depository")
        ]
        let creditAccounts = [
            Account(name: "Venture", value: 832.31, type: "Credit")
        ]
        let loanAccounts = [
            Account(name: "Consolidated 01", value: 30831.42, type: "Student Loan")
        ]
        
        institutions.append(Institution(name: "Bank of America", logoUrl: "someurl", accounts: bankAccounts))
        institutions.append(Institution(name: "Capital One", logoUrl: "someurl", accounts: creditAccounts))
        institutions.append(Institution(name: "Nelnet", logoUrl: "someurl", accounts: loanAccounts))
    }
    // ------------------------------------

}
