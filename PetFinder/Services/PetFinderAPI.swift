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
    static let requestBaseURL = "https://api.petfinder.com/v2"
    
    private static var url: String!
    private static let jsonDecoder = JSONDecoder()
    
    static func getPetsURL() -> URL{
        url = requestBaseURL + "/animals"
        return URL(string: url)!
    }
    
//    static func filterPetsURL(filterPetType: String?, filterPetBreed: Bool, filterPet: [String:String]?) -> URL {
//        let urlComponents = URLComponents(string: requestBaseURL)
//            
//        switch filterPetType {
//        case let petType:
//            url = requestBaseURL + "/types/\(String(describing: petType))"
//            if filterPetBreed {
//                url = requestBaseURL + "/types/\(String(describing: petType))/breeds"
//                if let filterPet = filterPet {
//                    for (key, value) in filterPet {
//                        var queryParams = [URLQueryItem]()
//                        let queryParam = URLQueryItem(name: key, value: value)
//                        queryParams.append(queryParam)
//                        return (urlComponents?.url)!
//                    }
//                }
//            }
//        }
//        return URL(string: url)!
//    }
//        
//        static func filterPetTypeURL(petType: String?) -> URL {
//            url = requestBaseURL + "/types/\(String(describing: petType))"
//            return URL(string: url)!
//        }
//    
//    static func filterPetBreedURL(petBreed: String?) -> URL {
//        url = requestBaseURL + "/types/\(String(describing: petBreed))"
//        return URL(string: url)!
//    }
//    
//    static func filterPet(filterPetType: Bool, filterPetBreed: Bool, filterPet: [String:String]?) -> URL {
//        if filterPetType {
//            url = requestBaseURL + "/types/\(petType)"
//        }
//    }

    static func getToken(jsonData data : Data) -> Result<Token, Error> {
        do {
            let token = try jsonDecoder.decode(Token.self, from: data)
            return .success(token)
        } catch {
            return .failure(error)
        }
    }
    
//    static func getAnimals(JSONData data: Data) -> Result<[Animal], Error> {
//        do {
//            let animals = try jsonDecoder.decode([Animal].self, from: data)
//            return .success(animals)
//        } catch {
//            return .failure(error)
//        }
//    }
    static func getAnimals(JSONData data: Data) -> Result<[Pet], Error> {
        do {
            let petfinderResponse = try jsonDecoder.decode(PetfinderAPIResponse.self, from: data)
            return .success(petfinderResponse.animals)
        } catch {
            return .failure(error)
        }
    }
    
    static func parseResponseError(JSONError data: Data) -> Result<ResponseError, Error> {
        do {
            let responseError = try jsonDecoder.decode(ResponseError.self, from: data)
            return .success(responseError)
        } catch {
            return .failure(error)
        }
    }
}

