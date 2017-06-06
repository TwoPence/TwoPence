//
//  Transfer.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Unbox

enum TransferType: String, UnboxableEnum {
    case Spending
    case Jolt
    case Sponsor
    
    var color: UIColor {
        switch self.rawValue {
        case "Spending":
            return AppColor.PaleGreen.color
        case "Jolt":
            return AppColor.Cream.color
        case "Sponsor":
            return AppColor.Blue.color
        default:
            return UIColor.white
        }
    }
    
    var icon: UIImage {
        switch self.rawValue {
        case "Spending":
            return #imageLiteral(resourceName: "spendingIconGreen")
        case "Jolt":
            return #imageLiteral(resourceName: "lightningboltcream")
        case "Sponsor":
            return #imageLiteral(resourceName: "sponsorIconBlue")
        default:
            return UIImage()
        }
    }
    
    var label: String {
        switch self.rawValue {
        case "Spending":
            return "TwoPence"
        case "Jolt":
            return "Jolts"
        case "Sponsor":
            return "Sponsors"
        default:
            return "No Label"
        }
    }
    
    var text: String {
        switch self.rawValue {
        case "Spending":
            return "TwoPence Withdrawals"
        case "Jolt":
            return "Jolts"
        case "Sponsor":
            return "Sponsor Contributions"
        default:
            return "No Text"
        }
    }
}

class Transfer: Unboxable {
    var amount: Double
    var date: Date
    var transactions: [Transaction]
    var type: TransferType
    var pending: Bool
    private var eomDate: Date
    
    required init(unboxer: Unboxer) throws {
        self.amount = try unboxer.unbox(key: "amount")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        self.date = try unboxer.unbox(key: "date", formatter: dateFormatter)
        self.transactions = try unboxer.unbox(key: "transactions")
        self.type = try unboxer.unbox(key: "type")
        self.pending = try unboxer.unbox(key: "pending")
        self.eomDate = self.date.endOfMonth()
    }
    
    class func withArray(dictionaries: [Dictionary<String, Any>]) throws -> [Transfer] {
        var transfers = [Transfer]()
        
        for dict in dictionaries {
            let transfer: Transfer = try unbox(dictionary: dict)
            transfers.append(transfer)
        }
        
        return transfers
    }
    
    class func typeTotals(transfers: [Transfer]) -> [(type: TransferType, total: Double)] {
        
        var typeTotals = [(type: TransferType, total: Double)]()
        var types = [TransferType]()
        types.append(.Spending)
        types.append(.Jolt)
        types.append(.Sponsor)
        for type in types {
            let amounts = transfers.filter({$0.type == type}).map({$0.amount}) as [Double]
            let total = amounts.reduce(0, +)
            typeTotals.append((type: type, total: total))
        }
        
        return typeTotals
    }
    
    class func groupByEomDate(transfers: [Transfer]) -> [(eomDate: Date, transfers: [Transfer])] {
        var group = [(eomDate: Date, transfers: [Transfer])]()
        var allEomDates = [Date]()
        for transfer in transfers {
            allEomDates.append(transfer.eomDate)
        }
        let eomDates = Set<Date>(allEomDates)
        
        for eomDate in eomDates {
            let transfers = transfers.filter({$0.eomDate == eomDate})
            group.append((eomDate: eomDate, transfers: transfers))
        }
        
        return group.sorted(by: { $0.eomDate > $1.eomDate })
    }
    
}
