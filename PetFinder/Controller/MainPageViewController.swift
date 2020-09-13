//
//  MainPageViewController.swift
//  Royal Keep
//
//  Created by MohammadHossein on 4/8/1399 AP.
//  Copyright © 1399 Chargoon. All rights reserved.
//

import UIKit

class MainPageViewController: UITabBarController {
    
//    var settingsTabNavigationController : UINavigationController!
    var petsTabNavigationController : UINavigationController!
    var favoritesTabNavigationController : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    //MARK: - Setup TabBar
    
    private func setupTabBar() {
        
//        settingsTabNavigationController = UINavigationController(rootViewController: SettingsViewController())
        petsTabNavigationController =  UINavigationController(rootViewController: PetsTableViewController())
        favoritesTabNavigationController = UINavigationController(rootViewController: FavoritesTableViewController())
        
        self.viewControllers = [
                                petsTabNavigationController,
                                favoritesTabNavigationController
                               ]
        
        let item1 = UITabBarItem(title: "Pets", image: UIImage(named: "Pets"), tag: 1)
        let item2 = UITabBarItem(title:"Favorites",image:UIImage(named:"Favorite Pets"), tag:2)
//        let item3 = UITabBarItem(title: "یادداشت ها", image: UIImage(named: "Note"), tag: 3)
        
        petsTabNavigationController.tabBarItem = item1
        favoritesTabNavigationController.tabBarItem = item2
//        notesTabNavigationController.tabBarItem = item3
        
//        self.selectedIndex = 2
    }
}

