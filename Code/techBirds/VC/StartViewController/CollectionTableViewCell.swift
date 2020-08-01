//
//  CollectionTableViewCell.swift
//  techBirds
//
//  Created by admin on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    let avalibleApps = [UIImage(named: "sberLogo"), UIImage(named: "sberKZ"), UIImage(named: "sberBR")]
    let avalibleTitles = ["Сбербанк","Сбербанк Казахстан", "БПС-Сбербанк"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - UICollectionViewDataSource
extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avalibleApps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? AppsCollectionViewCell {
            cell.configure(with: avalibleApps[indexPath.row], and: avalibleTitles[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
}
