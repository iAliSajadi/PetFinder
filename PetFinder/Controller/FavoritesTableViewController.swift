//
//  FavoritesTableViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/12/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    let store = DataStore()
    let imageStore = ImageStore()
    var pets = [Pet]()
    var pet: Pet!
    private var index: Int!
    private var petMediumImages = [UIImage]()
    private var petSmallImages = [UIImage]()
    private var imageSize: String!
    let identifier = "petsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPets()
    }
    
    private func setupNavigationBar() {
//        self.navigationItem.searchController = searchController
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        self.navigationItem.title = "Favorite Pets"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UINib(nibName: "PetsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    @objc private func getPetPhoto(at index: Int, imageSize: String?) -> [UIImage] {
        let getPetPhotosResult = store.getPetImages(for: pets[index].photos, petID: Int(pets[index].id), imageSize: imageSize)
        switch getPetPhotosResult {
        case let .success(petPhotos):
            if imageSize == "small" {
                petSmallImages = petPhotos
                return petSmallImages
            } else {
                petMediumImages = petPhotos
                return petSmallImages
            }
        case let .failure(error):
            print(error)
            petSmallImages.removeAll()
            petSmallImages.append(UIImage(named: "No Photo")!)
        }
        return petSmallImages
    }
    
    private func fetchPets() {
        let fetchResult = store.fetchPet()
            switch fetchResult {
            case let .success(pets):
//                self.pets.removeAll()
                self.pets = pets
                tableView.reloadData()
            case let .failure(error):
                print(error)
            }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        index = indexPath.row
        
        imageSize = "small"
        _ = getPetPhoto(at: indexPath.row, imageSize: imageSize)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PetsTableViewCell
        
        let item = pets[indexPath.row]
        cell.petName.text = item.name
        cell.petAge.text = item.age
        cell.petGender.text = item.gender
        cell.petBreed.text = item.breeds.primary
        cell.petImage.image = petSmallImages.first

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathForSelectedRow?.row {
            let pet = self.pets[index]
            
            imageSize = "medium"
            _ = getPetPhoto(at: indexPath.row, imageSize: imageSize)
            
            //            print(petMediumImages.count)
            //            print(petMediumImages!)
            
            let petDetailsNavigationController = UINavigationController(rootViewController: PetDetailsViewController())
            let petDetailsViewController = petDetailsNavigationController.topViewController as! PetDetailsViewController
            petDetailsViewController.pet = pet
            petDetailsViewController.sentPetImages = petSmallImages
            petDetailsViewController.sentPetMediumImages = petMediumImages
            
            self.present(petDetailsNavigationController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var identifier = 0
        let petId = String(pets[indexPath.row].id)
        
        store.deletePet(at: indexPath.row)
        pets.remove(at: indexPath.row)
        
        for _ in 0..<petSmallImages.count {
            identifier += 1
            let key = petId + String(identifier) + "S"
            imageStore.deleteImage(forKey: key)
        }
        
        for _ in 0..<petMediumImages.count {
            identifier += 1
            let key = petId + String(identifier) + "M"
            imageStore.deleteImage(forKey: key)
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
