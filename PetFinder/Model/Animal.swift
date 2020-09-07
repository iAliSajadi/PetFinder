//
//  Pet.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

class Animal: Codable {
    let id: Int
    let name: String
    let url: String
    let type: String
    let species: String
    let breeds: String
    let age: String
    let gender: String
    let attributes: [String:Bool]
    let photos: [[String:URL]]
}
