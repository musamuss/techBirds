//
//  AppsCollectionViewCell.swift
//  techBirds
//
//  Created by admin on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class AppsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    
    
    func configure(with image: UIImage?, and title: String?) {
        imageView?.image = image
        titleLabel?.text = title
    }
}
