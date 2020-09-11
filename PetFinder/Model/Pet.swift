//
//  Pet.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import Foundation

struct PetfinderAPIResponse: Codable {
    let animals: [Pet]
    
    enum CodingKeys: String, CodingKey {
        case animals
    }
}

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
    
    enum CodingKeys: String, CodingKey {
        case primary
        case secondary
        case mixed, unknown
    }
}

// MARK: - Colors
struct Colors: Codable {
    let primary: String?
    let secondary: String?
    let tertiary: String?
    
    enum CodingKeys: String, CodingKey {
        case primary
        case secondary
        case tertiary
    }
}

// MARK: - Photo
struct Photo: Codable {
    let small, medium, large, full: String
    
    enum CodingKeys: String, CodingKey {
        case small, medium, large, full
    }
}

struct Contact: Codable {
    let email, phone: String?
    
    enum CodingKeys: String, CodingKey {
        case email, phone
    }
}

//struct Environment: Codable {
//    let children: NSNumber?
//    let dogs: NSNumber?
//    let cats: NSNumber?
//}

// MARK: - Animal

struct Pet: Codable {
    
    let id: Int
    let name: String
    let type: String
    let species: String
    let breeds: Breeds
    let age: String
    let gender: String
    let size: String
    let colors: Colors
    let attributes: Attributes
    //    let environment: Environment
    let status: String
    let contact: Contact
    let organizationId: String
//    let description: String?
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case id
        case type, name, species, breeds, age, gender, size, colors, attributes, status, contact
        case organizationId = "organization_id"
        case photos
    }
    
//    enum AttributesCodingKeys: String, CodingKey {
//        case spayedNeutered = "spayed_neutered"
//        case houseTrained = "house_trained"
//        case declawed
//        case specialNeeds = "special_needs"
//        case shotsCurrent = "shots_current"
//    }
//
//    enum BreedsCodingKeys: String, CodingKey {
//        case primary
//        case secondary
//        case mixed, unknown
//    }
//
//    enum ColorsCodingKeys: String, CodingKey {
//        case primary
//        case secondary
//        case tertiary
//    }
//
//    enum PhotosCodingKeys: String, CodingKey {
//        case small, medium, large, full
//    }
//
//    enum ContactCodingKeys: String, CodingKey {
//        case email, phone
//    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.species = try container.decode(String.self, forKey: .species)
        self.breeds = try container.decode(Breeds.self, forKey: .breeds)
        self.age = try container.decode(String.self, forKey: .age)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.size = try container.decode(String.self, forKey: .size)
        self.colors = try container.decode(Colors.self, forKey: .colors)
        self.attributes = try container.decode(Attributes.self, forKey: .attributes)
        self.status = try container.decode(String.self, forKey: .status)
        self.contact = try container.decode(Contact.self, forKey: .contact)
        self.organizationId = try container.decode(String.self, forKey: .organizationId)
//        self.description = try container.decode(String.self, forKey: .description)
        self.photos = try container.decode([Photo].self, forKey: .photos)
    }
}

