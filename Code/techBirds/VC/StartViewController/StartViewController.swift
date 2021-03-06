//
//  StartViewController.swift
//  techBirds
//
//  Created by admin on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class StartViewController: UITableViewController {

    let avalibleTeam = Review.Team.all
    var rowSelected: Int?
    var rewiew: [Review]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Команды"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Demo", style: .plain, target: self, action: #selector(demoTapped))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CommentViewController, let rowSelected = rowSelected {
            let selectedTeam = avalibleTeam[rowSelected]
            
            App.current.updateTeam(selectedTeam)
            
            vc.navigationItem.title = selectedTeam.rawValue
            vc.reviews = rewiew
        }
    }
    
    @objc func demoTapped() {
        performSegue(withIdentifier: "openDemo", sender: self)
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
        case 1: return avalibleTeam.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "collectionViewCell", for: indexPath) as? CollectionTableViewCell {
            
            return cell
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "commandCell", for: indexPath) as? CommandsTableViewCell {
                cell.configure(with: avalibleTeam[indexPath.row].rawValue)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != 0 {
            rowSelected = indexPath.row
            let selectedApp = App.current.selectedApp
            App.current.appStore.getReviews(appID: selectedApp, page: 1) { (succses) in
                self.rewiew = succses
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toComments", sender: self)
                }
            }
        }
    }
        
}
