//
//  UserAlerts.swift
//  Royal Keep
//
//  Created by Ali Sajadi on 6/27/20.
//  Copyright © 2020 Chargoon. All rights reserved.
//

import UIKit

struct UserAlert {
    
    //MARK: - Show Info Alert Method
    
    func showInfoAlert(title: String?, message: String?, view: UIViewController, action: (() -> Void)?) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // create alert action
        let action = UIAlertAction(title: "Yes", style: .default) {_ in
            action!()
        }
        
        // add action to alert
        alert.addAction(action)
        
        // show the alert
        view.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Show Decision Alert Method
    
    func showDecisionAlert(title: String?, message: String?, view: UIViewController, cancelAction: (() -> Void)?, confirmAction: (() -> Void)?) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // create alert action
        let cancelAction = UIAlertAction(title: "خیر", style: .cancel) { _ in
            cancelAction!()
        }
        
        let confirmAction = UIAlertAction(title: "بله", style: .destructive) { _ in
            confirmAction!()
//            UserDefaults.standard.removeObject(forKey: "userInfo")
//            let loginViewController = sourceViewController?.navigationController?.tabBarController?.navigationController?.viewControllers.first as? LoginViewController
//            loginViewController?.userName.text = ""
//            loginViewController?.password.text = ""
//            sourceViewController?.navigationController?.tabBarController?.navigationController?.popToRootViewController(animated: true)
            
        }
        
        // add actions to alert
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        // show the alert
        view.present(alert, animated: true, completion: nil)
    }
}
