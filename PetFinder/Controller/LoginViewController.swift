//
//  LoginViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/7/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var APIKeyTextField: UITextField!
    @IBOutlet var secretTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    let store = DataStore()
    let userAlert = UserAlert()
    let showPasswordImageView = UIImageView()
    var tapShowSecret = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIKeyTextField.delegate = self
        secretTextField.delegate = self
        
        createTapGestureRecognizer()
        showSecret()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserSession()
    }
    
    
    //MARK:- Check UserDefaults for auto login

    private func checkUserSession() {

        if UserDefaults.standard.string(forKey: "accessToken") == nil {
            return
        } else if !CheckNetworkReachability.isConnectedToNetwork() {
            userAlert.showInfoAlert(title: "Network Reachability Error" , message: "Internet Connection not Available!", view: self, action: ({}))
        } else {
            navigationController!.pushViewController(MainPageViewController(), animated: true)
        }
    }
    
    //MARK:- Setup navigation bar
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Login method

    @IBAction func login(_ sender: UIButton) {
        
        let APIKey = APIKeyTextField.text?.trimmingCharacters(in: .whitespaces)
        let secret = secretTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if let APIKey = APIKey, !APIKey.isEmpty, let secret = secret, !secret.isEmpty {
            store.tokenRequest(APIKey: APIKey, secret: secret
              , taskCompletion: { (loginResult) in
                if loginResult == "ok" {
                    print("Login successful")
                } else {
                    self.userAlert.showInfoAlert(title: "Error", message: "There is a problem in login, Please try again", view: self, action: {()})
                }
            }, errorCompletion: { (loginErrorResult) in
                if case let .success(loginError) = loginErrorResult {
                    if loginError.title == "invalid_client" {
                        self.userAlert.showInfoAlert(title: "Error", message: "Authentication failed, API Key or secret is incorrect", view: self, action: {()})
                    }
                }
            })
        } else if let APIKey = APIKey, APIKey.isEmpty {
            userAlert.showInfoAlert(title: "Error", message: "The API Key Cann't be empty", view: self, action: {()})
        } else if let secret = secret, secret.isEmpty {
            userAlert.showInfoAlert(title: "Error", message: "The secret Cann't be empty", view: self, action: {()})
        }
    }
    
    //MARK: - Dismissing KeyBoard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // Login with enter key
        login(loginButton)
        
        return true
    }
    
    private func createTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - trimming whitespaces in API Key TextField

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            APIKeyTextField.text = APIKeyTextField.text?.trimmingCharacters(in: .whitespaces)
        }
    }
    
    //MARK: - Show Secret method

    private func showSecret(){
        
        showPasswordImageView.image = UIImage(named: "Eye Splash")
        showPasswordImageView.isUserInteractionEnabled = true

        secretTextField.rightView = showPasswordImageView
        secretTextField.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleShowSecret))
        tapGestureRecognizer.numberOfTapsRequired = 1
        showPasswordImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func toggleShowSecret() {
        if(tapShowSecret == true) {
            secretTextField.isSecureTextEntry = false
            showPasswordImageView.image = UIImage(named: "Eye")
        } else {
            secretTextField.isSecureTextEntry = true
            showPasswordImageView.image = UIImage(named: "Eye Splash")
        }
        
        tapShowSecret = !tapShowSecret
    }
}
