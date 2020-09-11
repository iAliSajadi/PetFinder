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
    private var petPhoto: UIImage!
    private let store = DataStore()
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
        
//        refreshControl = UIRefreshControl()
//        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl!.tintColor = UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00)
//        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
        let petImage = getPetPhotos(at: indexPath.row)
        let item: Pet!
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
        cell.petImage.image = petImage
        //        cell.petImage.image = petPhoto
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathForSelectedRow?.row {
            let pet = self.pets[index]
            let petImage = getPetPhotos(at: index)
            let petDetailsNavigationController = UINavigationController(rootViewController: PetDetailsViewController())
            let petDetailsViewController = petDetailsNavigationController.topViewController as! PetDetailsViewController
            petDetailsViewController.pet = pet
            petDetailsViewController.sentPetImage = petImage
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
    
//    @objc func refresh(refreshControl: UIRefreshControl){
//        self.pets.removeAll()
//        getPets()
//        tableView.reloadData()
//        refreshControl.endRefreshing()
//    }
    
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
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                isSearching = false
            } else {
                isSearching = true
                
                filteredPets = pets.filter({ (pet) -> Bool in
                    if let filter = self.filter {
                        print(filter)
                        switch filter {
                        case "Name":
                            return pet.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                        case "Type":
                            return pet.type.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                        case "Breed":
                            return pet.breeds.primary.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                        case "Gender":
                            return pet.gender.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                        case "Size":
                            return pet.size.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                        case "Color":
                            return pet.size.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                        default:
                            isSearching = false
                        }
                        return true
                    } else {
                    return false
                    }
                })
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        isSearching = true
        filter = searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        
    }
}

