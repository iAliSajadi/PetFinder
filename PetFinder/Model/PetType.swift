//
//  PetType.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/10/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

struct PetType: Codable {
    let name: String
    let colors: [String]
    let genders: [String]
}
