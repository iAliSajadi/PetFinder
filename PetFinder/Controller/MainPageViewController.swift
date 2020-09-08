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
//    var archiveTabNavigationController : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    //MARK: - Setup TabBar
    
    private func setupTabBar() {
        
//        settingsTabNavigationController = UINavigationController(rootViewController: SettingsViewController())
        petsTabNavigationController =  UINavigationController(rootViewController: PetsTableViewController())
//        archiveTabNavigationController = UINavigationController(rootViewController: ArchiveViewController())
        
        self.viewControllers = [
                                petsTabNavigationController
                               ]
        
        let item1 = UITabBarItem(title: "Pets", image: UIImage(named: "Pets"), tag: 1)
//        let item2 = UITabBarItem(title:"آرشیو",image:UIImage(named:"Archive"), tag:2)
//        let item3 = UITabBarItem(title: "یادداشت ها", image: UIImage(named: "Note"), tag: 3)
        
        petsTabNavigationController.tabBarItem = item1
//        archiveTabNavigationController.tabBarItem = item2
//        notesTabNavigationController.tabBarItem = item3
        
//        self.selectedIndex = 2
    }
}

