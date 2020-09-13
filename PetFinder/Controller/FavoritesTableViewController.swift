//
//  FavoritesTableViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/12/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    private let store = DataStore()
    private let imageStore = ImageStore()
    private var pets = [Pet]()
    private var pet: Pet!
    private var filteredPets = [Pet]()
    private var isSearching: Bool = false
    private var index: Int!
    private var petMediumImages = [UIImage]()
    private var petSmallImages = [UIImage]()
    private var imageSize: String!
    let userAlert = UserAlert()
    var spinner = UIActivityIndicatorView()
    let identifier = "petsTableViewCell"
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "SEARCH PETS"
        controller.searchBar.sizeToFit()
        controller.searchBar.searchBarStyle = .prominent
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupSearchBar()
        activityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPets()
        checkNetworkReachability()
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
        searchController.isActive = false
        
        spinner.startAnimating()
        spinner.backgroundColor = .white
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkNetworkReachability()
    }
    
    //MARK:- Check Network Reachability

    private func checkNetworkReachability() {

       if !CheckNetworkReachability.isConnectedToNetwork() {
            userAlert.showInfoAlert(title: "Network Error" , message: "You are not connected to internet", view: self, action: ({}))
        }
    }
    
    //MARK:- Prepare navigation bar
    
    private func setupNavigationBar() {
        self.navigationItem.searchController = searchController
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        self.navigationItem.title = "Favorite Pets"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK:- Prepare table view
    
    private func setupTableView() {
        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UINib(nibName: "PetsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        //MARK: Prepare Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.tintColor = UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00)
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    //MARK:- Get pet photos from API
    
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
    
    //MARK:- Get pet photos from disk
    
    private func fetchPets() {
        let fetchResult = store.fetchPet()
        switch fetchResult {
        case let .success(pets):
            self.pets = pets
            self.spinner.stopAnimating()
            self.spinner.hidesWhenStopped = true
            tableView.reloadData()
        case let .failure(error):
            print(error)
        }
    }
    
    //MARK:- Activity Indicator
    
    func activityIndicator() {
        spinner = UIActivityIndicatorView()
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.center = self.tableView.center
        self.view.addSubview(spinner)
    }
    
    // MARK: - Table view data source
    
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
        cell.petAge.text = item.age
        cell.petGender.text = item.gender
        cell.petBreed.text = item.breeds.primary
        cell.petImage.image = petSmallImages.first
        cell.favoriteButton.isHidden = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathForSelectedRow?.row {
            let pet = self.pets[index]
            
            imageSize = "medium"
            _ = getPetPhoto(at: indexPath.row, imageSize: imageSize)
            
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
        
        petMediumImages.forEach {_ in
            identifier += 1
            let key = petId + String(identifier) + "S"
            imageStore.deleteImage(forKey: key)
        }
        
        petMediumImages.forEach {_ in
            identifier += 1
            let key = petId + String(identifier) + "M"
            imageStore.deleteImage(forKey: key)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK:- Pull to refresh method
    
    @objc func refresh(refreshControl: UIRefreshControl){
        self.pets.removeAll()
        fetchPets()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension FavoritesTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    enum ScopeButtonIndex: Int {
        case All     = 0
        case Name    = 1
        case Typpe   = 2
        case Breed   = 3
        case Size    = 4
        case Gender  = 5
    }
    
    // MARK:- Search bar extension

    private func setupSearchBar() {
        searchController.searchBar.scopeButtonTitles = ["All", "Name", "Type", "Breed", "Size", "Gender"]
        searchController.searchBar.selectedScopeButtonIndex = 0
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        isSearching = false
        searchController.searchBar.selectedScopeButtonIndex = 0
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterPetsTableView(for: searchController.searchBar.selectedScopeButtonIndex, searchText: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterPetsTableView(for: selectedScope, searchText: searchBar.text!)
    }
    
    func filterPetsTableView(for scopeButtonIndex: Int, searchText: String) {
        if searchController.searchBar.text!.isEmpty {
            filteredPets = pets
        }
        
        switch scopeButtonIndex {
        case ScopeButtonIndex.All.rawValue:
            isSearching = false
        case ScopeButtonIndex.Name.rawValue:
            isSearching = true
            filteredPets = pets.filter({ (pet) -> Bool in
                return pet.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil })
        case ScopeButtonIndex.Typpe.rawValue:
            isSearching = true
            print("type")
            filteredPets = pets.filter({ (pet) -> Bool in
                return pet.type.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil })
        case ScopeButtonIndex.Breed.rawValue:
            isSearching = true
            filteredPets = pets.filter({ (pet) -> Bool in
                return pet.breeds.primary.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil })
        case ScopeButtonIndex.Size.rawValue:
            isSearching = true
            filteredPets = pets.filter({ (pet) -> Bool in
                return pet.size.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil })
        case ScopeButtonIndex.Gender.rawValue:
            isSearching = true
            filteredPets = pets.filter({ (pet) -> Bool in
                return pet.gender.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil })
        default:
            print("")
        }
        tableView.reloadData()
    }
}
