//
//  SettingsViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/13/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let userAlert = UserAlert()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    //MARK: - Setup NavigationBar
    
    private func setupNavigationBar() {
      
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action:  #selector(logout))
    }

    //MARK: - Logout Button
    
    @objc func logout() {
        
        userAlert.showDecisionAlert(title: "Logging Out", message: "Are you sure you want to leave us?", view: self, cancelAction: {()}) {
            
            UserDefaults.standard.removeObject(forKey: "accessToken")
            let loginViewController = self.navigationController?.tabBarController?.navigationController?.viewControllers.first as? LoginViewController
            loginViewController?.APIKeyTextField.text = ""
            loginViewController?.secretTextField.text = ""
            self.navigationController?.tabBarController?.navigationController?.popToRootViewController(animated: true)
        }
        
    }
}
