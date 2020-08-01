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
    var review: [Review]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
// MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    
}
// MARK: - UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let review = review else { return 0 }
        return review.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        
        return cell
    }
    
    
}
