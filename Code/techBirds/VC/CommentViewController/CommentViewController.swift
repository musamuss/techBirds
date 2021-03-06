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
    
    var appInfo: AppInfo?
    
    var reviews: [Review]?
    var teamReviews: [Review] {
        (reviews ?? []).filter { $0.team == App.current.selectedTeam }
    }
    
    var metric: Double {
        let likeReviews = teamReviews.filter { ($0.category == .like) && ($0.category == .proposal) }
        
        return Double(likeReviews.count) / Double(teamReviews.count)
    }
    
    var isDataLoading = false
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAppInfo()
        self.reviews = classifyReviews(reviews ?? [])
    }
}
// MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let review = teamReviews[indexPath.row]
        
        let categoriesText = composeNiceText(review.categoryPropability)
        let teamsText = composeNiceText(review.teamPropability)
        
        let alert = UIAlertController(title: review.title, message: "\(categoriesText)\n\(teamsText)", preferredStyle: .alert)
        alert.addAction(.init(title: "Ок", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func composeNiceText(_ dict: [String: Double]) -> String {
        var text = ""
        
        dict.keys.forEach { key in
            guard let value = dict[key] else { return }
            text.append("\(key): \(value)\n")
        }
        
        return text
    }
}

// MARK: - UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .header: return 1
        case .reviews: return teamReviews.count
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
            
            cell.configure(
                appName: appInfo?.name ?? "Сбербанк Онлайн",
                rating: appInfo?.rating ?? 5,
                metric: metric
            )
            
            return cell
            
        case .reviews:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentsTableViewCell else {
                return defaultCell
            }
            
            cell.configure(review: teamReviews[indexPath.row])
            
            return cell
            
        default:
            return defaultCell
        }
    }
}

extension CommentViewController {
    func getAppInfo() {
        let currentApp = App.current.selectedApp
        App.current.appStore.getAppInfo(appID: currentApp) { [unowned self] info in
            DispatchQueue.main.async {
                self.appInfo = info
                self.tableView.reloadData()
            }
        }
    }
    
    func getNewReviews(page: Int) {
        let currentApp = App.current.selectedApp
        App.current.appStore.getReviews(appID: currentApp, page: page) { [unowned self] newReviews in
            DispatchQueue.main.async {
                self.reviews?.append(contentsOf: self.classifyReviews(newReviews))
                self.tableView.reloadData()
            }
        }
    }

    func classifyReviews(_ reviews: [Review]) -> [Review] {
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
        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                getNewReviews(page: self.pageNo)
            }
        }
    }
}

extension CommentViewController {
    enum Section: Int {
        case header
        case reviews
    }
}
