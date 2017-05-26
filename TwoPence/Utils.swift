//
//  Utils.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 5/16/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class Utils: NSObject {
    
    class func setupGradientBackground(topColor: CGColor, bottomColor: CGColor, view: UIView, frame: CGRect? = nil, index: UInt32? = nil) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.2, 1.0]
        gradientLayer.frame = frame ?? view.frame
        view.layer.insertSublayer(gradientLayer, at: index ?? 0)
    }
    
    class func getMilestoneImageName(name: String) -> String {
        var imageName = name
        if imageName == "fifteen_hundred" || imageName == "two_thousand" {
            imageName = "one_thousand"
        }
        
        return imageName
    }
    
    class func findContactsOnBackgroundThread ( completionHandler:@escaping (_ contacts:[CNContact]?)->()) {
        DispatchQueue.global(qos: .userInitiated).async(execute: { () -> Void in
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey] as [Any] //CNContactIdentifierKey
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var contacts = [CNContact]()
            CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
            
            if #available(iOS 10.0, *) {
                fetchRequest.mutableObjects = false
            } else {
                // Fallback on earlier versions
            }
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .userDefault
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            print("\(contactStoreID)")
            
            
            do {
                
                try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                    //do something with contact
                    if contact.phoneNumbers.count > 0 {
                        contacts.append(contact)
                    }
                    
                }
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(contacts)
            })
        })
    }
}
