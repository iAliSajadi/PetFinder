//
//  Spinner.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/9/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class Spinner {
    
    var spinner: UIActivityIndicatorView!
    
    func spinner(shouldSpin status: Bool) {
        if status == true {
            spinner.isHidden = false
            spinner.startAnimating()
        } else {
            spinner.isHidden = true
            spinner.stopAnimating()
        }
    }
}
