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
    var isDataLoading = false
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviews = classifiedReviews(reviews: reviews ?? [])
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

extension CommentViewController {
    func getNewData(page: Int) {
        App.current.appStore.getReviews(appID: .sberbankOnline, page: page) { (succses) in
            DispatchQueue.main.async {
                let responce = self.classifiedReviews(reviews: succses)
                self.reviews?.append(contentsOf: responce)
                self.tableView.reloadData()
            }
        }
    }
    
    func classifiedReviews(reviews: [Review]) -> [Review] {
        return reviews.map { review in
            var classifiedReview: Review
            classifiedReview = App.current.categoriesClassifier.classify(review)
            classifiedReview = App.current.teamsClassifier.classify(classifiedReview)
            return classifiedReview
        }
    }
}

extension CommentViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

            print("scrollViewDidEndDragging")
            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    getNewData(page: self.pageNo)
                }
            }


    }
}
