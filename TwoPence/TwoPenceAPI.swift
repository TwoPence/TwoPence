//
//  TwoPenceClient.swift
//  TwoPence
//
//  Created by Utkarsh Sengar on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import Alamofire
import Cely
import Unbox

//TODO: Fix url concat with Router pattern in Alamofire

class TwoPenceAPI: NSObject {
    static let sharedClient = TwoPenceAPI(baseURL: "http:localhost:4000/")
    let baseURL: String
    var loginSuccess:  (() -> ())?
    var loginFailure:  ((Error) -> ())?
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func logout(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        Alamofire.request(self.baseURL + "v1/logout", method: .post).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    Cely.changeStatus(to: .loggedOut)
                    print(result)
                    success()
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func login(email: String, password: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(self.baseURL + "v1/login", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    let apiToken = json["token"] as! String
                    User.save(apiToken, as: .token)
                    Cely.changeStatus(to: .loggedIn)
                }
            case .failure(let error):
                self.loginFailure?(error)
            }
        }
    }
    
    func getProfile(success: @escaping (UserProfile) -> (), failure: @escaping (Error) -> ()){
        
        Alamofire.request(self.baseURL + "v1/profile/", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    do {
                        let profile: UserProfile = try unbox(dictionary: result as! Dictionary)
                        success(profile)
                    } catch {
                        print("An error occured: \(error)")
                        failure(error)
                    }
                }
            case .failure(let error):
                failure(error)
            }
            
        }
    }
    
    func getAggTransactions(success: @escaping ([AggTransactions]) -> (), failure: @escaping (Error) -> ()){
        
        Alamofire.request(self.baseURL + "v1/agg-transactions", method: .get)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    do{
                        let response = result as! Dictionary<String, Any>
                        let aggTransactions: [AggTransactions] = try AggTransactions.withArray(dictionaries: response["data"] as! Array)
                        success(aggTransactions)
                    } catch {
                        print("An error occured: \(error)")
                        failure(error)
                    }
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getAccounts(success: @escaping ([Account]) -> (), failure: @escaping (Error) -> ()){
        
        Alamofire.request(self.baseURL + "v1/accounts", method: .get)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        do{
                            let response = result as! Dictionary<String, Any>
                            let accounts: [Account] = try Account.withArray(dictionaries: response["data"] as! Array)
                            success(accounts)
                        } catch {
                            print("An error occured: \(error)")
                            failure(error)
                        }
                    }
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func getMilestones(success: @escaping ([DebtMilestone]) -> (), failure: @escaping (Error) -> ()){
        
        Alamofire.request(self.baseURL + "v1/debt-milestones", method: .get)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        do{
                            let response = result as! Dictionary<String, Any>
                            let milestones: [DebtMilestone] = try DebtMilestone.withArray(dictionaries: response["data"] as! Array)
                            success(milestones)
                        } catch {
                            print("An error occured: \(error)")
                            failure(error)
                        }
                    }
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func getFinMetrics(success: @escaping (UserFinMetrics) -> (), failure: @escaping (Error) -> ()){
        
        Alamofire.request(self.baseURL + "v1/fin-metrics", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    do {
                        let finMetrics: UserFinMetrics = try unbox(dictionary: result as! Dictionary)
                        success(finMetrics)
                    } catch {
                        print("An error occured: \(error)")
                        failure(error)
                    }
                }
            case .failure(let error):
                failure(error)
            }
            
        }
    }
    
    func getComputationMetrics(success: @escaping (ComputationMetrics) -> (), failure: @escaping (Error) -> ()){
        
        Alamofire.request(self.baseURL + "v1/computation-metrics", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    do {
                        let computationMetrics: ComputationMetrics = try unbox(dictionary: result as! Dictionary)
                        success(computationMetrics)
                    } catch {
                        print("An error occured: \(error)")
                        failure(error)
                    }
                }
            case .failure(let error):
                failure(error)
            }
            
        }
    }
}

