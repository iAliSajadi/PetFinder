//
//  Pet.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

struct PetfinderAPIResponse: Codable {
    let animals: [Animal]
}

// MARK: - Animal
struct Animal: Codable {
    let id: Int
    let type: String
    let name: String
    let species: String
    let breeds: Breeds
    let age: String
    let gender: String
    let size: String
    let colors: Colors
    let attributes: Attributes
    let status: String
    let contact: Contact
    let organizationId: String
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case id
        case type, name, species, breeds, age, gender, size, colors, attributes, status, contact
        case organizationId = "organization_id"
        case photos
    }
}

//enum Age: String, Codable {
//    case adult = "Adult"
//    case baby = "Baby"
//    case young = "Young"
//}

//enum Gender: String, Codable {
//    case female = "Female"
//    case male = "Male"
//}

// MARK: - Attributes
struct Attributes: Codable {
    let spayedNeutered, houseTrained: Bool
    let declawed: Bool?
    let specialNeeds, shotsCurrent: Bool
    
    enum CodingKeys: String, CodingKey {
        case spayedNeutered = "spayed_neutered"
        case houseTrained = "house_trained"
        case declawed
        case specialNeeds = "special_needs"
        case shotsCurrent = "shots_current"
    }
}

// MARK: - Breeds
struct Breeds: Codable {
    let primary: String
    let secondary: String?
    let mixed, unknown: Bool
}

//enum Secondary: String, Codable {
//    case cattleDog = "Cattle Dog"
//    case domesticShortHair = "Domestic Short Hair"
//    case mixedBreed = "Mixed Breed"
//}

// MARK: - Colors
struct Colors: Codable {
    let primary: String?
    let secondary: String?
    let tertiary: String?
}

// MARK: - Photo
struct Photo: Codable {
    let small, medium, large, full: String
}

struct Contact: Codable {
    let email: String?
    let phone: String?
}

//enum Size: String, Codable {
//    case large = "Large"
//    case medium = "Medium"
//    case small = "Small"
//}

//enum Species: String, Codable {
//    case cat = "Cat"
//    case dog = "Dog"
//}
