//
//  Store.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

class Store {
    
    private var accessToken: String!
    private let session: URLSession = {
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
                        self.accessToken = token.accessToken
                        //                    print(self.accessToken!)
                        UserDefaults.standard.set(self.accessToken, forKey: "accessToken")
                        taskCompletion("ok")
                    case let .failure(error):
                        print(error)
                        taskCompletion("nok")
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
    
    func getAllAnimals() throws {
        let url = PetFinderAPI.animalsURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let accessToken = accessToken {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            throw TokenError.MissingAccessToken
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
            }
        }
        task.resume()
    }
    
    func processResponseError(data: Data?) -> Result<ResponseError,Error> {
        guard let JSONError = data else {
            return .failure(StoreError.NoJSONData)
        }
        return PetFinderAPI.parseResponseError(JSONError: JSONError)
    }
}
