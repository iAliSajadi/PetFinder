//
//  Errors.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

enum TokenError: Error {
    case MissingAccessToken
}

enum StoreError: Error {
    case NoJSONData
}

enum ImageStoreError: Error {
    case SavingPhotoError
}

enum ParseJSONError: Error {
    case BadJSONFormat
}

enum PhotoError: Error {
    case imageCreationError
    case missingPhotosURLs
    case getImageError
}
