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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .header: return 1
        case .reviews: return (reviews ?? []).count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        
        switch Section(rawValue: indexPath.section) {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as? ReviewsHeaderCell else {
                return defaultCell
            }
            
            cell.configure(appName: "Сбербанк Онлайн", rating: 2, metric: "дней без прорыва")
            
            return cell
            
        case .reviews:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentsTableViewCell,
                let reviews = reviews else {
                return defaultCell
            }
            
            cell.configure(review: reviews[indexPath.row])
            
            return cell
            
        default:
            return defaultCell
        }
    }
}

extension CommentViewController {
    enum Section: Int {
        case header
        case reviews
    }
}
