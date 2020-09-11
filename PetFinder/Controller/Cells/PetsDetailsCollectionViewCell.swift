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
        iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
