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
    var spinner = UIActivityIndicatorView()
    
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
                
//        getPets()
        setupTableView()
        setupNavigationBar()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPets()
        activityIndicator()
        checkNetworkReachability()
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
        searchController.isActive = false
        
        spinner.startAnimating()
        spinner.backgroundColor = .white
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
    
    // MARK: - Get animals method
    
    private func getPets() {
        store.getPets() { (getAnimalsResult) in
            switch getAnimalsResult {
            case let .success(pets):
                self.pets = pets
                self.spinner.stopAnimating()
                self.spinner.hidesWhenStopped = true
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    //MARK:- Get pet Photos
    
    @objc private func getPetPhoto(at index: Int, imageSize: String?) -> [UIImage] {
            
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
    
    func activityIndicator() {
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.center = self.view.center
        self.view.addSubview(spinner)
    }
    
    // MARK:- Setup navigation bar
    
    private func setupNavigationBar() {
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Pets"
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    // MARK:- Setup table view
    
    private func setupTableView() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UINib(nibName: "PetsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        //MARK: Prepare pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.tintColor = UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00)
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    // MARK:- Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false {
            if pets.count == 0 {
                tableView.setEmptyView()
            } else {
                tableView.restore()
            }
            return pets.count
        } else {
            if filteredPets.count == 0 {
                tableView.setEmptyView()
            } else {
                tableView.restore()
            }
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
        
        cell.indexPath = indexPath
        cell.delegate = self
        
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
            petDetailsViewController.previousVC = true
            
            self.present(petDetailsNavigationController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
        
    // MARK:- Pull to refresh
    
    @objc func refresh(refreshControl: UIRefreshControl){
        self.pets.removeAll()
        getPets()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK:- Search bar extension

extension PetsTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    enum ScopeButtonIndex: Int {
        case All     = 0
        case Name    = 1
        case Typpe   = 2
        case Breed   = 3
        case Size    = 4
        case Gender  = 5
    }
    
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

// MARK:- Extension For PetsTableViewCellDelegate

extension PetsTableViewController: PetsTableViewCellDelegate {
    
    func onClickFavoriteButtonFor(indexPath: Int) {
        let saveResult = store.savePet(pet: pets[indexPath])
            switch saveResult {
            case let .success(result):
                print(result)
            case let .failure(error):
                print(error)
        }
        userAlert.showInfoAlert(title: "\(pets[indexPath].name)", message: "Now is your favorite now", view: self, action: {()})
    }
}


