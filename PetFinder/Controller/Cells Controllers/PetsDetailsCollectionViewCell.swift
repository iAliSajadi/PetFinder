//
//  PetsDetailsCollectionViewCell.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/11/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class PetDetailsCollectionViewCell: UICollectionViewCell {
    
    let petImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
//        backgroundColor = .gray
        addSubview(petImage)
        petImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            petImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            petImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            petImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16)
        ])
    }
}
