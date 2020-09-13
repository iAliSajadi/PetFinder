//
//  TableView+EmptyView.swift
//  PetFinder
//
//  Created by Ali Sajadi on 9/13/20.
//  Copyright © 2020 Ali Sajadi. All rights reserved.
//

import UIKit

extension UITableView {
    func setEmptyView() {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let image = UIImageView(image: UIImage(named: "No Search Result"))
        image.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(image)
        image.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
