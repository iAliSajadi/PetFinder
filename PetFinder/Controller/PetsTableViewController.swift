//
//  PetsTableViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/8/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

//protocol PetsTableViewControllerDelegate {
//    func sendSelectedPet(selectedPet: Pet)
//}

class PetsTableViewController: UITableViewController {
    
    private let identifier = "petsTableViewCell"
    private var index: Int!
    private var filter: String?
    private var searchBarPlaceholder: String!
    private var isSearching: Bool = false
    private var pets = [Pet]()
    private var filteredPets = [Pet]()
    private var imageSize: String!
    private var petImage: UIImage!
    private var petMediumImages = [UIImage]()
    private var petSmallImages = [UIImage]()
    private let store = DataStore()
    private let imageStore = ImageStore()
    private let userAlert = UserAlert()
//    var delegate: PetsTableViewControllerDelegate!
    var petDetailsViewController: PetDetailsViewController!
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = self.searchBarPlaceholder
        controller.searchBar.sizeToFit()
        controller.searchBar.searchBarStyle = .prominent
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        getPets()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
        searchController.isActive = false
    }
    
    // MARK: - Get animals method
    
    private func getPets() {
        store.getPets() { (getAnimalsResult) in
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
    
//    @objc private func getPetPhotos(at index: Int) -> UIImage {
//
//        let imageSizes = ["small", "medium±", "large", "full"]
//
//        var petPhoto: UIImage!
//        //        print(pets[0].photos)
//        //        store.getPetPhotos(for: pets[index].photos) { (getPetPhotosResult) in
//        //            switch getPetPhotosResult {
//        //            case let .success(petPhotos):
//        //                petPhoto = petPhotos.first!
//        //            case let .failure(error):
//        //                print(error)
//        //                petPhoto = UIImage(named: "No Image")!
//        //            }
//        //        }
//        let getPetPhotosResult = store.getPetImages(for: pets[index].photos, petID: pets[index].id, imageSize: nil)
//        switch getPetPhotosResult {
//        case let .success(petPhotos):
//            petPhoto = petPhotos.first!
//        case let .failure(error):
//            print(error)
//            petPhoto = UIImage(named: "No Photo")!
//        }
//        return petPhoto
//    }
    
    @objc private func getPetPhoto(at index: Int, imageSize: String?) -> [UIImage] {
            
    //        let imageSizes = ["small", "medium±", "large", "full"]
            
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
            
        let getPetPhotosResult = store.getPetImages(for: pets[index].photos, petID: pets[index].id, imageSize: imageSize)
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
    
    // MARK: Setup navigation bar
    
    private func setupNavigationBar() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Pets"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let filterButton = UIBarButtonItem(image: UIImage(named: "Filter 1"), style: .plain, target: self, action: #selector(filterPets))
        self.navigationItem.rightBarButtonItems = [filterButton]
    }
    
    // MARK: Setup table view
    
    private func setupTableView() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UINib(nibName: "PetsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.tintColor = UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00)
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false{
            return pets.count
        } else {
            return filteredPets.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        index = indexPath.row
        let item: Pet!
        
        imageSize = "small"
        _ = getPetPhoto(at: indexPath.row, imageSize: imageSize)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PetsTableViewCell
        
        if isSearching == false {
            item = pets[indexPath.row]
        } else {
            item = filteredPets[indexPath.row]
        }
        
        cell.petName.text = item.name
        cell.petGender.text = item.gender
        cell.petAge.text = item.age
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
            petDetailsViewController.previousVC = true
            
            self.present(petDetailsNavigationController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleForHeader = UILabel(frame: CGRect(x: 5, y: 0, width: view.frame.size.width - 10, height: 50))
        titleForHeader.numberOfLines = 0
        titleForHeader.textAlignment = .center
        titleForHeader.font = UIFont(name: "Nexa Bold", size: 12)!
        titleForHeader.attributedText = NSAttributedString(string: "You can search pets by name, type, species, breed, age, gender, size and color",
                                                           attributes: [.font: UIFont(name: "Nexa light", size: 14)!,
                                                                        .foregroundColor: UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00)])
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        headerView.addSubview(titleForHeader)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func refresh(refreshControl: UIRefreshControl){
        self.pets.removeAll()
        getPets()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func filterPets() {
        userAlert.showTypeOfFilter(title: "Filter Pets", message: "Filter pets by:", view: self) { (actionTitle) in
            self.filter = actionTitle
            self.searchBarPlaceholder = actionTitle
            self.searchController.searchBar.placeholder = "Search By \(actionTitle)"
//            print(actionTitle)
        }
    }
}

extension PetsTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    private func setupSearchBar() {
        searchController.searchBar.scopeButtonTitles = ["Name", "Type", "Breed", "Size", "Gender", "Color"]
        searchController.searchBar.selectedScopeButtonIndex = 0
    }

    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.isEmpty {
            isSearching = false
        }
//        filterPetsTableView(for: searchController.searchBar.selectedScopeButtonIndex, searchText: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filterPetsTableView(for: selectedScope, searchText: searchBar.text!)
    }
    
//    func filterPetsTableView(for scopeButtonIndex: Int, searchText: String) {
//            if searchText.isEmpty {
//                isSearching = false
//            }
//
//            print(searchText)
//            switch scopeButtonIndex {
//            case ScopeButtonIndex.Name.rawValue:
//                isSearching = true
//                filteredPets = pets.filter({ (pet) -> Bool in
//                    return pet.name.lowercased().contains(searchText.lowercased())})
//            case ScopeButtonIndex.petType.rawValue:
//                isSearching = true
//                print(scopeButtonIndex)
//                filteredPets = pets.filter({ (pet) -> Bool in
//                    return pet.type.lowercased().contains(searchText.lowercased())})
//            case ScopeButtonIndex.Breed.rawValue:
//                isSearching = true
//                filteredPets = pets.filter({ (pet) -> Bool in
//                    return pet.breeds.primary.lowercased().contains(searchText.lowercased())})
//            case ScopeButtonIndex.Size.rawValue:
//                isSearching = true
//                filteredPets = pets.filter({ (pet) -> Bool in
//                    return pet.size.lowercased().contains(searchText.lowercased())})
//            case ScopeButtonIndex.Gender.rawValue:
//                isSearching = true
//                filteredPets = pets.filter({ (pet) -> Bool in
//                    return pet.gender.lowercased().contains(searchText.lowercased())})
//            case ScopeButtonIndex.Color.rawValue:
//                isSearching = true
//                filteredPets = pets.filter({ (pet) -> Bool in
//                    return (pet.colors.primary?.lowercased().contains(searchText.lowercased()))!})
//            default:
//                isSearching = false
//        }
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        isSearching = false
        filter = searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
    }
}

