//
//  StartViewController.swift
//  techBirds
//
//  Created by admin on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class StartViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension StartViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        switch section {
        case 0: return 1
        case 1: return 10
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "collectionViewCell", for: indexPath) as? CollectionTableViewCell {
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commandCell", for: indexPath)
            return cell
        }
    }
}

