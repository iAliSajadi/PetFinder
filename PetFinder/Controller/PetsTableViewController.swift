//
//  PetsTableViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/8/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

protocol PetsTableViewControllerDelegate {
    func sendSelectedPet(selectedPet: Animal)
}

class PetsTableViewController: UITableViewController {
    
    private let identifier = "petsTableViewCell"
    private var index: Int!
    private var pets = [Animal]()
    private var petPhoto: UIImage!
    private let store = DataStore()
    var delegate: PetsTableViewControllerDelegate!
    
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
//                self.refreshControl?.endRefreshing()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // MARK: - Get pet Photos
    
    @objc private func getPetPhotos(at index: Int) -> UIImage {
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
            petPhoto = UIImage(named: "No Photo")!
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
        
//        refreshControl = UIRefreshControl()
//        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl!.tintColor = UIColor(red: 102/255, green: 4/255, blue: 179/255, alpha: 1.0)
//        refreshControl!.addTarget(self, action: #selector(getPetPhotos(at:)), for: .valueChanged)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PetsTableViewCell
        
        cell.petName.text = self.pets[indexPath.row].name
        cell.petGender.text = pets[indexPath.row].gender
        cell.petAge.text = pets[indexPath.row].age
        cell.petBreed.text = pets[indexPath.row].breeds.primary
        cell.petImage.image = getPetPhotos(at: indexPath.row)
//        cell.petImage.image = petPhoto
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathForSelectedRow?.row {
            let pet = self.pets[index]
            delegate.sendSelectedPet(selectedPet: pet)
            self.navigationController?.pushViewController(PetDetailsViewController(), animated: true)
        }
    }
    
}
