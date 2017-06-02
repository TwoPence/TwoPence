//
//  ContactsAPI.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 6/1/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Contacts

class ContactsAPI: NSObject {
    static let sharedClient = ContactsAPI()

    var store = CNContactStore()
    
    func findAllContacts(_ completionHandler: @escaping (_ contacts: [CNContact]) -> Void) {
        var contacts = [CNContact]()
        checkAccessStatus({ (accessGranted) -> Void in
            if accessGranted {
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey,
                                           CNContactEmailAddressesKey,
                                           CNContactPhoneNumbersKey,
                                           CNContactImageDataAvailableKey,
                                           CNContactThumbnailImageDataKey] as [Any]
                        let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as! [CNKeyDescriptor])
                        CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
                        
                        if #available(iOS 10.0, *) {
                            fetchRequest.mutableObjects = false
                        } else {
                            // Fallback on earlier versions
                        }
                        fetchRequest.unifyResults = true
                        fetchRequest.sortOrder = .userDefault
                        
                        try self.store.enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                            if contact.phoneNumbers.count > 0 {
                                contacts.append(contact)
                            }
                        }
                        
                        completionHandler(contacts)
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }
    
    func findContactsWithName(_ name: String, _ completionHandler: @escaping (_ contacts: [CNContact]) -> Void) {
        checkAccessStatus({ (accessGranted) -> Void in
            if accessGranted {
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
                        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey,
                                           CNContactEmailAddressesKey,
                                           CNContactPhoneNumbersKey,
                                           CNContactImageDataAvailableKey,
                                           CNContactThumbnailImageDataKey] as [Any]
                        CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
                        
                        let contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor])
                        completionHandler(contacts)
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }
    
    func checkAccessStatus(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        let store = CNContactStore()
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied, .notDetermined:
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    print("access denied")
                }
            })
        default:
            completionHandler(false)
        }
    }
}
