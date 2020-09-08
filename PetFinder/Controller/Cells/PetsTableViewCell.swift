//
//  PetsTableViewCell.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/8/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

class PetsTableViewCell: UITableViewCell {

    @IBOutlet var petName: UILabel!
    @IBOutlet var petType: UILabel!
    @IBOutlet var petAge: UILabel!
    @IBOutlet var petGender: UILabel!
    @IBOutlet var petImage: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        petImage.layer.cornerRadius = 10
    }
}
