//
//  PetsTableViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/8/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class PetsTableViewController: UITableViewController {
    
    private let identifier = "petsTableViewCell"
    private var index: Int!
    private var pets = [Animal]()
    private var petPhoto: UIImage!
    private let store = DataStore()
    
    var test = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAnimals()
        setupTableView()
        setupNavigationBar()
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
    
    // MARK: - Get pet Photos
    
    private func getPetPhotos(at index: Int) -> UIImage {
        var petPhoto: UIImage!
//        print(pets[0].photos)
//        store.getPetPhotos(for: pets[index].photos) { (getPetPhotosResult) in
//            switch getPetPhotosResult {
//            case let .success(petPhotos):
//                petPhoto = petPhotos.first!
//            case let .failure(error):
//                print(error)
//                petPhoto = UIImage(named: "No Image")!
//            }
//        }
        let getPetPhotosResult = store.test(for: pets[index].photos, petID: pets[index].id)
        switch getPetPhotosResult {
        case let .success(petPhotos):
            petPhoto = petPhotos.first!
        case let .failure(error):
            print(error)
            petPhoto = UIImage(named: "No Image")!
        }
        return petPhoto
    }
    
    // MARK: - Setup navigation bar
    
    private func setupNavigationBar() {
        
        self.navigationItem.title = "Pets"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Setup table view
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "PetsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.rowHeight = 115
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
        index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PetsTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 7
        cell.petImage.layer.cornerRadius = cell.petImage.frame.height / 7
        
        cell.petName.text = self.pets[indexPath.row].name
        cell.petGender.text = pets[indexPath.row].gender
        cell.petAge.text = pets[indexPath.row].age
        cell.petBreed.text = pets[indexPath.row].breeds.primary
        cell.petImage.image = getPetPhotos(at: indexPath.row)
//        cell.petImage.image = petPhoto
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("..................")
//        getAnimals()
//        petPhoto = getPetPhotos(at: indexPath.row)
//    }
    
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
