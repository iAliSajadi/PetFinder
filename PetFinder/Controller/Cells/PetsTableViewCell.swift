//
//  PetsTableViewCell.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/8/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

protocol PetsTableViewCellDelegate {
    func onClickFavoriteButtonFor(indexPath: Int)
}

class PetsTableViewCell: UITableViewCell {

    var delegate: PetsTableViewCellDelegate!
    var indexPath: IndexPath!
    
    @IBOutlet var petName: UILabel!
    @IBOutlet var petBreed: UILabel!
    @IBOutlet var petAge: UILabel!
    @IBOutlet var petGender: UILabel!
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var cellView: UIView!
    @IBOutlet var cell: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellView.layer.cornerRadius = cellView.frame.height / 7
        petImage.layer.cornerRadius = petImage.frame.height / 7
        petImage.layer.borderColor = UIColor(red: 0.39, green: 0.02, blue: 0.71, alpha: 1.00).cgColor
        petImage.layer.cornerRadius = 5.0
        petImage.layer.borderWidth = 2
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        configureImageView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configureImageView() {
//        
//    }
    
    @IBAction func setFavorite(_ sender: UIButton) {
        delegate.onClickFavoriteButtonFor(indexPath: indexPath.row)
    }
}
