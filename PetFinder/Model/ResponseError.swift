//
//  ResponseError.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

class ResponseError: Decodable {
    let status: Int
    let title: String
    let detail: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case title
        case detail
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(Int.self, forKey: .status)
        self.title = try container.decode(String.self, forKey: .title)
        self.detail = try container.decode(String.self, forKey: .detail)
    }
}
