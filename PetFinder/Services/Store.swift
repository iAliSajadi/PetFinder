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
    
    func tokenRequest(APIKey: String, secret: String, completion: @escaping (String) -> Void) {
        
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
            if let data = data, error == nil {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                let result = self.processTokenRequest(data: data, error: error)
                switch result {
                case let .success(token):
                    self.accessToken = token.accessToken
                    print(self.accessToken!)
                    completion("ok")
                case let .failure(error):
                    print(error)
                    completion("nok")
                }
            }
        }
        task.resume()
    }
    
    func processTokenRequest(data: Data?, error: Error?) -> Result<Token,Error> {
        guard let jsonData = data else {
            print("No JSON data")
            return .failure(error!)
        }
        return PetFinderAPI.getToken(jsonData: jsonData)
    }
}
