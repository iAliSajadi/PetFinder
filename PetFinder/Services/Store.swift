//
//  Store.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

class Store {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func tokenRequest(APIKey: String, secret: String, taskCompletion: @escaping (String) -> Void, errorCompletion: @escaping (Result<ResponseError,Error>) -> Void) {
        
        guard let url = URL(string: PetFinderAPI.tokenRequestBaseURL) else {
            print("URL is invalid...!!!")
            return
        }
        
        let params = "grant_type=client_credentials&client_id=\(APIKey)&client_secret=\(secret)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = params.data(using: .utf8, allowLossyConversion: true)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, let response = response as? HTTPURLResponse, error == nil {
                if response.statusCode == 401 {
                    let parseResponseErrorResult = self.processResponseError(data: data)
                    OperationQueue.main.addOperation {
                        errorCompletion(parseResponseErrorResult)
                    }
                } else {
                    let getTokeResult = self.processTokenRequest(data: data, error: error)
                    switch getTokeResult {
                    case let .success(token):
                        UserDefaults.standard.set(token.accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(APIKey, forKey: "APIKey")
                        UserDefaults.standard.set(secret, forKey: "secret")
                        
                        OperationQueue.main.addOperation {
                            taskCompletion("ok")
                        }
                        
                    case let .failure(error):
                        print(error)
                        OperationQueue.main.addOperation {
                            taskCompletion("nok")
                        }
                    }
                }
                
                //                if let jsonString = String(data: data, encoding: .utf8) {
                //                    print(jsonString)
                //                }
            }
        }
        task.resume()
    }
    
    func processTokenRequest(data: Data?, error: Error?) -> Result<Token,Error> {
        guard let jsonData = data else {
            print("No JSON data")
            return .failure(StoreError.NoJSONData)
        }
        return PetFinderAPI.getToken(jsonData: jsonData)
    }
    
    //    func getAnimals(filter: String?, Completion: @escaping (Result<[Animal],Error>) -> Void) {
    //        let url = PetFinderAPI.petFinderURL(filter: filter)
    //        print(url)
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    //
    //        let task = session.dataTask(with: request) { (data, response, error) in
    //            if let data = data, let response = response as? HTTPURLResponse, error == nil {
    //                if response.statusCode == 401 {
    //                    let parseResponseErrorResult = self.processResponseError(data: data)
    //                    if case let .success(responseError) = parseResponseErrorResult, responseError.detail == "Access token invalid or expired" {
    //                        if let APIKey = UserDefaults.standard.string(forKey: "APIKey"), let secret = UserDefaults.standard.string(forKey: "secret") {
    //                            self.tokenRequest(APIKey: APIKey, secret: secret, taskCompletion: { (tokenRequestResult) in
    //                                switch tokenRequestResult {
    //                                case "ok":
    //                                    self.getAnimals(filter: filter, Completion: {_ in ()})
    //                                default:
    //                                    print("Cannot get access token")
    //                                }
    //                            }, errorCompletion: {_ in ()})
    //                        }
    //                    }
    //                } else {
    //                    let getAnimalsResult = self.processGetAnimalsRequest(data: data, error: error)
    //                    OperationQueue.main.addOperation {
    //                        Completion(getAnimalsResult)
    //                    }
    //                }
    //            }
    //        }
    //        task.resume()
    //    }
    
    func getAnimals(filter: String?, Completion: @escaping (Result<[Animal],Error>) -> Void) {
        let url = PetFinderAPI.petFinderURL(filter: filter)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, let response = response as? HTTPURLResponse, error == nil {
                //                if response.statusCode == 401 {
                //                        if let APIKey = UserDefaults.standard.string(forKey: "APIKey"), let secret = UserDefaults.standard.string(forKey: "secret") {
                //                            self.tokenRequest(APIKey: APIKey, secret: secret, taskCompletion: { (tokenRequestResult) in
                //                                switch tokenRequestResult {
                //                                case "ok":
                //                                    print("Successfully gets access token")
                //                                    print(self.accessToken!)
                //                                    self.getAnimals(filter: filter, Completion: {_ in ()})
                //                                default:
                //                                    print("Cannot get access token")
                //                                }
                //                            }, errorCompletion: {_ in ()})
                //                        }
                //                } else {
                //                    let getAnimalsResult = self.processGetAnimalsRequest(data: data, error: error)
                //                    OperationQueue.main.addOperation {
                //                        Completion(getAnimalsResult)
                //                    }
                //                }
                
                //                if let jsonString = String(data: data, encoding: .utf8) {
                //                    print(jsonString)
                //                }
                
                let getAnimalsResult = self.processGetAnimalsRequest(data: data, error: error)
                OperationQueue.main.addOperation {
                    Completion(getAnimalsResult)
                }
            }
        }
        task.resume()
    }
    
    private func processGetAnimalsRequest(data: Data?, error: Error?) -> Result<[Animal],Error> {
        guard let JSONData = data else {
            return .failure(StoreError.NoJSONData)
        }
        return PetFinderAPI.getAnimals(JSONData: JSONData)
    }
    
    func processResponseError(data: Data?) -> Result<ResponseError,Error> {
        guard let JSONError = data else {
            return .failure(StoreError.NoJSONData)
        }
        return PetFinderAPI.parseResponseError(JSONError: JSONError)
    }
}
