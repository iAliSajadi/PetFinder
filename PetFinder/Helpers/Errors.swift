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

enum ParseJSONError: Error {
    case BadJSONFormat
}