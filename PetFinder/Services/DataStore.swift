//
//  Store.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class DataStore {
    
    let imageStore = ImageStore()
    var accessToken: String!
    var url: URL!
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    let petArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = documentsDirectories.first!
            return documentDirectory.appendingPathComponent("pet.plist")
    }()
    
    //MARK:- Token request method
    
    func tokenRequest(APIKey: String, secret: String, taskCompletion: @escaping (String) -> Void, errorCompletion: @escaping (Result<ResponseError,Error>) -> Void) {
        
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
            if let data = data, let response = response as? HTTPURLResponse, error == nil {
                if response.statusCode == 401 {
                    let parseResponseErrorResult = self.processResponseError(data: data)
                    OperationQueue.main.addOperation {
                        errorCompletion(parseResponseErrorResult)
                    }
                } else {
                    let getTokeResult = self.processTokenRequest(data: data, error: error)
                    switch getTokeResult {
                    case let .success(token):
                        self.accessToken = token.accessToken
                        UserDefaults.standard.set(token.accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(APIKey, forKey: "APIKey")
                        UserDefaults.standard.set(secret, forKey: "secret")
                        
                        OperationQueue.main.addOperation {
                            taskCompletion("ok")
                        }
                        
                    case let .failure(error):
                        print(error)
                        OperationQueue.main.addOperation {
                            taskCompletion("nok")
                        }
                    }
                }
                
                //                if let jsonString = String(data: data, encoding: .utf8) {
                //                    print(jsonString)
                //                }
            }
        }
        task.resume()
    }
    
    //MARK:- Process the token request method

    func processTokenRequest(data: Data?, error: Error?) -> Result<Token,Error> {
        guard let jsonData = data else {
            print("No JSON data")
            return .failure(StoreError.NoJSONData)
        }
        return PetFinderAPI.getToken(jsonData: jsonData)
    }
    
    //MARK:- Get animals request method

    func getPets(Completion: @escaping (Result<[Pet],Error>) -> Void) {
           url = PetFinderAPI.getPetsURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, let response = response as? HTTPURLResponse, error == nil {
                                // If the data contains error
                                if response.statusCode == 401 {
                                        // The access token has expired
                                        if let APIKey = UserDefaults.standard.string(forKey: "APIKey"), let secret = UserDefaults.standard.string(forKey: "secret") {
                                            // Request Again
                                            self.tokenRequest(APIKey: APIKey, secret: secret, taskCompletion: {
                                                (tokenRequestResult) in
                                                    switch tokenRequestResult {
                                                    case "ok":
                                                        print("Successfully gets access token")
                                                        UserDefaults.standard.removeObject(forKey: "accessToken")
                                                        UserDefaults.standard.set(self.accessToken, forKey: "accessToken")
                                                        self.getPets(Completion: {_ in ()})
                                                    default:
                                                        print("Cannot get access token")
                                                    }
                                                }, errorCompletion: {_ in ()})
                                            }
                                } else {
                                    let getPetsResult = self.processGetPetsRequest(data: data, error: error)
                                    OperationQueue.main.addOperation {
                                        Completion(getPetsResult)
                                    }
                                }
                
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print(jsonString)
//                }
            }
        }
        task.resume()
    }
    
    //MARK:- Process the get animals request
    
    private func processGetPetsRequest(data: Data?, error: Error?) -> Result<[Pet],Error> {
        guard let JSONData = data else {
            return .failure(StoreError.NoJSONData)
        }
        return PetFinderAPI.getAnimals(JSONData: JSONData)
    }
    
    //MARK:- Get pet photos request method

//    func getPetPhotos(for photos: [Photo], completion: @escaping (Result<[UIImage],Error>) -> Void ) {
//        guard !photos.isEmpty else {
//            completion(.failure(PhotoError.missingPhotosURLs))
//            print("Missing Photos URLs")
//            return
//        }
//        for photo in photos {
//            let urlString = "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/49026715/5/?bust=1599635888&width=100"
//            print(urlString)
//            let photoURL = URL(string: urlString)!
//            print(photoURL)
//            let request = URLRequest(url: photoURL)
//
//            let task = session.dataTask(with: request) { (data, response, error) in
//                let getPetPhotosResult = self.processGetPetsPhotosRequest(data: data, error: error)
//                OperationQueue.main.addOperation {
//                    completion(getPetPhotosResult)
//                }
//            }
//            task.resume()
//        }
//        let urlString = "https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/49026715/5/?bust=1599635888&width=100"
//        guard let photoURL = URL(string: urlString) else {
//            print("Cannot create url")
//            return
//        }
//        var request = URLRequest(url: photoURL)
//        request.httpMethod = "GET"
//
//        let task = session.dataTask(with: request) { (data, response, error) in
//            print(error!)
//            print(response!)
//            let getPetPhotosResult = self.processGetPetsPhotosRequest(data: data, error: error)
//            OperationQueue.main.addOperation {
//                completion(getPetPhotosResult)
//            }
//        }
//        task.resume()
//    }
    
    func getPetImages(for photos: [Photo], petID: Int, imageSize: String?) -> Result<[UIImage],Error> {
        var petPhotos = [UIImage]()
        var petPhoto: UIImage
        var urlString: String
        var identifier = 0
        
        guard !photos.isEmpty else {
            print("Missing Photos URLs")
            return .failure(PhotoError.missingPhotosURLs)
        }
        
        func getPetPhoto(url: String, key: String) -> UIImage? {
            
            if let petPhoto = imageStore.fetchImage(forKey: key) {
                return petPhoto
            }
            let photoURL = URL(string: url)!
            guard let photoData = NSData(contentsOf: photoURL) else {
                return nil
            }
            let petPhoto = UIImage(data: photoData as Data)!
            imageStore.saveImage(petPhoto, forKey: key)
            return petPhoto
        }
        
        for photo in photos {
            identifier += 1
            let key = String(petID) + String(identifier)
            
            switch imageSize {
            case "small":
                urlString = photo.small
                petPhoto = getPetPhoto(url: urlString, key: key + "S")!
                petPhotos.append(petPhoto)
            case "medium":
                urlString = photo.medium
                petPhoto = getPetPhoto(url: urlString, key: key + "M")!
                petPhotos.append(petPhoto)
            default:
                return .failure(PhotoError.getImageError)
            }
            
        }
        return .success(petPhotos)
    }
    
    //MARK:- Process the get pet photos request

    private func processGetPetsPhotosRequest(data: Data?, error: Error?) -> Result<[UIImage],Error> {
        var petPhotos = [UIImage]()
        guard let photoData = data, let photo = UIImage(data: photoData) else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        petPhotos.append(photo)
        return .success(petPhotos)
    }
    
    //MARK:- Process the error

    func processResponseError(data: Data?) -> Result<ResponseError,Error> {
        guard let JSONError = data else {
            return .failure(StoreError.NoJSONData)
        }
        return PetFinderAPI.parseResponseError(JSONError: JSONError)
    }
    
    func savePet(pet: Pet) -> Result<String,Error> {
        var pets = [Pet]()
        if case let .success(getPets) = fetchPet() {
            print(getPets.count)
            for item in getPets {
                pets.append(item)
            }
        }
        pets.append(pet)
        do {
            let data = try encoder.encode(pets)
            try data.write(to: petArchiveURL, options: [.atomic])
            return .success("Save was successful")
        } catch {
            return .failure(ArchivingError.encodingError)
        }
    }
    
    func fetchPet() -> Result<[Pet],Error> {
        do {
            let data = try Data(contentsOf: petArchiveURL)
            let pets = try decoder.decode([Pet].self, from: data)
            print(pets.count)
            return .success(pets)
        } catch {
            print("Error reading in saved items: \(error)")
            return .failure(ArchivingError.fetchingError)
        }
    }
    
    func deletePet(at index: Int) {
        var pets = [Pet]()
            if case let .success(getPets) = fetchPet() {
                pets = getPets
            }
        pets.remove(at: index)
        do {
            let data = try encoder.encode(pets)
            try data.write(to: petArchiveURL, options: [.atomic])
        } catch {
            print(error)
        }
        print("Pet Deleted Successfully")
    }
}
