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
    
    var reviews: [Review]?
    var teamReviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let classifiedReviews: [Review] = (reviews ?? []).map { review in
            var classifiedReview: Review
                
            classifiedReview = App.current.categoriesClassifier.classify(review)
            classifiedReview = App.current.teamsClassifier.classify(classifiedReview)
                
            return classifiedReview
        }
        
        reviews = classifiedReviews
        teamReviews = classifiedReviews.filter { $0.team == App.current.selectedTeam }
    }

}
// MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    
}
// MARK: - UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reviews = reviews else { return 0 }
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentsTableViewCell, let reviews = reviews {
            cell.configure(review: reviews[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
