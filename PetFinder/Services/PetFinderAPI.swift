//
//  PetFinderAPI.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

struct PetFinderAPI {
    
    static let tokenRequestBaseURL = "https://api.petfinder.com/v2/oauth2/token"
    static let RequestBaseURL = "https://api.petfinder.com/v2"
    
    private static var url: String!
    private static let jsonDecoder = JSONDecoder()
    
    static func animalsURL() -> URL {
        url = RequestBaseURL + "/animals"
        return URL(string: url)!
    }

    static func getToken(jsonData data : Data) -> Result<Token, Error> {
        do {
            let token = try jsonDecoder.decode(Token.self, from: data)
            return .success(token)
        } catch {
            return .failure(ParseJSONError.BadJSONFormat)
        }
    }
    
    static func parseResponseError(JSONError data: Data) -> Result<ResponseError, Error> {
        do {
            let responseError = try jsonDecoder.decode(ResponseError.self, from: data)
            return .success(responseError)
        } catch {
            return .failure(ParseJSONError.BadJSONFormat)
        }
    }
}

