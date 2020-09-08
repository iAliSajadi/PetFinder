//
//  PetsTableViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/8/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class PetsTableViewController: UITableViewController {
    
    let identifier = "petsTableViewCell"
    private var pets = [Animal]()
    let store = Store()
    
    var test = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAnimals()
        setupTableView()
    }
    
    // MARK: - Get animals method
    
    private func getAnimals() {
        store.getAnimals(filter: nil) { (getAnimalsResult) in
            switch getAnimalsResult {
            case let .success(pets):
                self.pets = pets
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // MARK: - Setup table view
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "PetsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.rowHeight = 150
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        print("........................")
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PetsTableViewCell
        cell.petName.text = self.pets[indexPath.row].name
        cell.petGender.text = pets[indexPath.row].gender
        cell.petAge.text = pets[indexPath.row].age
        cell.petBreed.text = pets[indexPath.row].breeds.primary
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
    //        let headerTextField = UITextField(frame: CGRect(x: 20, y: 20, width: headerView.frame.width - 8, height: headerView.frame.height - 10))
    //        headerView.addSubview(headerTextField)
    //        return headerView
    //    }
    //
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    
}
