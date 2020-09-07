//
//  Token.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

class Token: Codable {
    let tokenType: String
    let expireTime: Int
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expireTime = "expires_in"
        case accessToken = "access_token"
    }
}
