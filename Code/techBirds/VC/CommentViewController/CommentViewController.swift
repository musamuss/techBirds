//
//  CommentViewController.swift
//  techBirds
//
//  Created by admin on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var withoutNegativeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }

}
// MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    
}
// MARK: - UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        cell.descriptionLabel.text = "{Eqesdfvgsdfgsgbew;nserhiv;w49u8phg 45425h g8hw2ghpfg p89h245pf9h2p45ftpw945gt p9{Eqesdfvgsdfgsgbew;nserhiv;w49u8phg 45425h g8hw2ghpfg p89h245pf9h2p45ftpw945gt p9{Eqesdfvgsdfgsgbew;nserhiv;w49u8phg 45425h g8hw2ghpfg p89h245pf9h2p45ftpw945gt p9{Eqesdfvgsdfgsgbew;nserhiv;w49u8phg 45425h g8hw2ghpfg p89h245pf9h2p45ftpw945gt p9{Eqesdfvgsdfgsgbew;nserhiv;w49u8phg 45425h g8hw2ghpfg p89h245pf9h2p45ftpw945gt p9{Eqesdfvgsdfgsgbew;nserhiv;w49u8phg 45425h g8hw2ghpfg p89h245pf9h2p45ftpw945gt p9"
        return cell
    }
    
    
}
