//
//  CollectionTableViewCell.swift
//  techBirds
//
//  Created by admin on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView?
    let avalibleApps = [UIImage(named: "sberLogo"), UIImage(named: "sberLogo"),UIImage(named: "sberKZ"), UIImage(named: "sberBR")]
    let avalibleTitles = ["Сбербанк-iOS","Сбербанк-Android","Сбербанк Казахстан", "БПС-Сбербанк"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView?.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - UICollectionViewDataSource
extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var currentApp: AppID = .sberbankOnline
        switch indexPath.row {
        case 0: currentApp = .sberbankOnline
        case 1: currentApp = .sberbankOnlineAndroid
        case 2: currentApp = .sberKazahstan
        case 3: currentApp = .sberBelorus
        default: break
        }
        App.current.updateApp(currentApp)
    }
    
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
