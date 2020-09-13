//
//  MainPageViewController.swift
//  Royal Keep
//
//  Created by MohammadHossein on 4/8/1399 AP.
//  Copyright © 1399 Chargoon. All rights reserved.
//

import UIKit

class MainPageViewController: UITabBarController {
    
    var settingsTabNavigationController : UINavigationController!
    var petsTabNavigationController : UINavigationController!
    var favoritesTabNavigationController : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    //MARK: - Setup TabBar
    
    private func setupTabBar() {
        
        petsTabNavigationController =  UINavigationController(rootViewController: PetsTableViewController())
        favoritesTabNavigationController = UINavigationController(rootViewController: FavoritesTableViewController())
        settingsTabNavigationController = UINavigationController(rootViewController: SettingsViewController())
        
        self.viewControllers = [
                                petsTabNavigationController,
                                favoritesTabNavigationController,
                                settingsTabNavigationController
                               ]
        
        let item1 = UITabBarItem(title: "Pets", image: UIImage(named: "Pets"), tag: 1)
        let item2 = UITabBarItem(title:"Favorite Pets",image:UIImage(named:"Favorite Pets"), tag:2)
        let item3 = UITabBarItem(title: "Settings", image: UIImage(named: "Setting"), tag: 3)
        
        petsTabNavigationController.tabBarItem = item1
        favoritesTabNavigationController.tabBarItem = item2
        settingsTabNavigationController.tabBarItem = item3        
    }
}

