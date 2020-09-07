//
//  Store.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

struct Store {
    
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func tokenRequest(APIKey: String, secret: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: PetFinderAPI.baseURL) else {
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
            }
        }
        task.resume()
    }
    
    static func proceesstokenRequest(data:Data, error: Error) -> Result<String, 
}
