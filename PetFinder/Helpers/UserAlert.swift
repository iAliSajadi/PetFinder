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
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) {_ in
            action!()
        }
        alert.addAction(action)
        
        view.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Show Decision Alert Method
    
    func showDecisionAlert(title: String?, message: String?, view: UIViewController, cancelAction: (() -> Void)?, confirmAction: (() -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
            cancelAction!()
        }
        
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            confirmAction!()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        view.present(alert, animated: true, completion: nil)
    }
    
}
