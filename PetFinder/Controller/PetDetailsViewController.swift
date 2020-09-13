//
//  PetDetailsViewController.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/9/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class PetDetailsViewController: UIViewController {
    
    var pet: Pet!
    var sentPetImage: UIImage?
    var sentPetMediumImages = [UIImage]()
    var sentPetImages = [UIImage]()
    let identifier = "collectionViewCell"
    
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var species: UILabel!
    @IBOutlet var primaryBreed: UILabel!
    @IBOutlet var secondaryBreed: UILabel!
    @IBOutlet var mixedBreed: UILabel!
    @IBOutlet var unknownBreed: UILabel!
    @IBOutlet var age: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var size: UILabel!
    @IBOutlet var primaryColor: UILabel!
    @IBOutlet var secondaryColor: UILabel!
    @IBOutlet var tertiaryColor: UILabel!
    @IBOutlet var spayedNeuteredAttribute: UILabel!
    @IBOutlet var houseTrainedAttribute: UILabel!
    @IBOutlet var declawedAttribute: UILabel!
    @IBOutlet var SpecialNeedsAttribute: UILabel!
    @IBOutlet var ShotsCurrentAttribute: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var childrenEnvironment: UILabel!
    @IBOutlet var dogsEnvironment: UILabel!
    @IBOutlet var catsEnvironment: UILabel!
    @IBOutlet var OrganizationId: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var petDescription: UILabel!
    @IBOutlet var primaryDetailsLbl: UILabel!
    @IBOutlet var photos: UILabel!
    @IBOutlet var speciesAndBreeds: UILabel!
    @IBOutlet var attributesAndEnvironment: UILabel!
    @IBOutlet var contactInfo: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var leftTopView: UIView!
    @IBOutlet var leftBottomView: UIView!
    @IBOutlet var rightTopView: UIView!
    @IBOutlet var rightBottomView: UIView!
    @IBOutlet var descriptionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configView()
        configImageView()
        configLabels()
        setPetDetails()
        configNavigationBar()
        setupCollectionView()
    }
    
    private func configView() {
        
        leftTopView.layer.cornerRadius = leftTopView.frame.height / 9
        
        leftBottomView.layer.cornerRadius = leftBottomView.frame.height / 9
        
        rightTopView.layer.cornerRadius = rightTopView.frame.height / 17
        
        rightBottomView.layer.cornerRadius = rightBottomView.frame.height / 9
        
        descriptionView.layer.cornerRadius = descriptionView.frame.height / 9

    }
    
    private func configImageView() {
        petImage.layer.cornerRadius = petImage.frame.height / 7
        petImage.layer.borderColor = UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00).cgColor
        petImage.layer.borderWidth = 2
    }
    
    private func configNavigationBar() {
        navigationItem.title = "Pet Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Favorite"), style: .plain, target: self, action: #selector(setFavorite))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closePetDetails))
    }
    
    @objc private func closePetDetails() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func setFavorite() {
        
    }
    
    private func configLabels() {
        descriptionLbl.layer.cornerRadius = descriptionLbl.frame.height / 7
        descriptionLbl.layer.borderColor = UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00).cgColor
        descriptionLbl.layer.masksToBounds = true
    }
    
    private func setPetDetails() {
        // Name
        name.text = pet.name
        
        // Species
        species.text = pet.species
        
        // Breed
        primaryBreed.text = pet.breeds.primary
        if let secondaryPetBreed = pet.breeds.secondary {
            secondaryBreed.text = secondaryPetBreed
        } else {
            secondaryBreed.text = "N/A"
        }
        if pet.breeds.mixed {
            mixedBreed.text = "Yes"
        } else {
            mixedBreed.text = "No"
        }
        
        // Age
        age.text = pet.age
        
        // Gender
        gender.text = pet.gender
        
        // Size
        size.text = pet.size
        
        // Color
        if let primaryPetColor = pet.colors.primary {
            primaryColor.text = primaryPetColor
        } else {
            primaryColor.text = "N/A"
        }
        
        if let secondaryPetColor = pet.colors.secondary {
            secondaryColor.text = secondaryPetColor
        } else {
            secondaryColor.text = "N/A"
        }
        
        if let tertiaryPetColor = pet.colors.tertiary {
            tertiaryColor.text = tertiaryPetColor
        } else {
            tertiaryColor.text = "N/A"
        }
        
        // Attributes
        if pet.attributes.spayedNeutered {
            spayedNeuteredAttribute.text = "Yes"
        } else {
            spayedNeuteredAttribute.text = "No"
        }
        
        if pet.attributes.houseTrained {
            houseTrainedAttribute.text = "Yes"
        } else {
            houseTrainedAttribute.text = "No"
        }
        
        if pet.attributes.specialNeeds {
            SpecialNeedsAttribute.text = "Yes"
        } else {
            SpecialNeedsAttribute.text = "No"
        }
        
        if pet.attributes.shotsCurrent {
            ShotsCurrentAttribute.text = "yes"
        } else {
            ShotsCurrentAttribute.text = "No"
        }
        
        // Status
        status.text = pet.status
        
//        // Environment
//        if pet.environment.children != nil {
//            childrenEnvironment.text = "Yes"
//        } else {
//            childrenEnvironment.text = "No"
//        }
//        
//        if pet.environment.dogs  != nil {
//            dogsEnvironment.text = "Yes"
//        } else {
//            dogsEnvironment.text =  "No"
//        }
//        
//        if pet.environment.cats  != nil {
//            catsEnvironment.text = "Yes"
//        } else {
//            catsEnvironment.text = "No"
//        }
        
        // Organization
        OrganizationId.text = pet.organizationId
        
        // Contact
        phone.text = pet.contact.phone
        
        // Description
//        if let description = pet.description {
//        petDescription.text = description
//        } else {
//            petDescription.text = "N/A"
//        }
        
        if let sentPetImage = sentPetMediumImages.first {
            petImage.image = sentPetImage
        }
    }
    
    private func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(PetDetailsCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.layer.cornerRadius = petImage.frame.height / 7
        collectionView.layer.borderColor = UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00).cgColor
        collectionView.layer.borderWidth = 2
    }
}

extension PetDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !sentPetImages.isEmpty {
            return sentPetMediumImages.count
        } else {
            return 1
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PetDetailsCollectionViewCell
            
            if !sentPetImages.isEmpty {
    //            cell.petImage.image = sentPetImages[indexPath.row]
                cell.petImage.image = sentPetMediumImages[indexPath.row]
            } else {
                cell.petImage.image = UIImage(named: "No Photo")
            }
            
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: (collectionView.frame.width / 3) - 16, height: 184)
            return CGSize(width: 130, height: 180)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    }
}
