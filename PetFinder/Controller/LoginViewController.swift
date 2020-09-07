//
//  LoginViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var APIKeyTextField: UITextField!
    @IBOutlet var secretTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: UIButton) {
        if let APIKey = APIKeyTextField.text?.trimmingCharacters(in: .whitespaces), !APIKey.isEmpty, let secret = secretTextField.text?.trimmingCharacters(in: .whitespaces), !secret.isEmpty {
            Store.tokenRequest(APIKey: <#T##String#>, secret: <#T##String#>, completion: <#T##(Result<String, Error>) -> Void#>)
        }
    }
}
