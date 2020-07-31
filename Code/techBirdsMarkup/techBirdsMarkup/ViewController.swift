//
//  ViewController.swift
//  techBirdsMarkup
//
//  Created by Artem Belkov on 31.07.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var progressField: NSTextField!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var ratingField: NSTextField!
    @IBOutlet weak var reviewField: NSTextField!
    
    @IBOutlet weak var parameterBox: NSComboBox!
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    private let pagesCount = 100 / 50
    
    private var currentPage = 0
    private var reviews: [Review] = []
    
    private var currentReview = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parameterBox.removeAllItems()

        indicator.startAnimation(self)
        indicator.isHidden = false
        loadReviews { [unowned self] in
            self.indicator.stopAnimation(self)
            self.indicator.isHidden = true

            self.showReview(for: self.currentReview)
        }
    }
    
    private func showReview(for index: Int) {
        guard index < reviews.count else { return }
        
        let review = reviews[index]
        
        progressField.stringValue = "\(currentReview + 1)/\(reviews.count)"
        usernameField.stringValue = review.author
        ratingField.stringValue = String(repeating: "⭐️", count: review.rating)
        reviewField.stringValue = review.title + " " + review.content
        
        parameterBox.addItems(withObjectValues: Review.Team.all.map { $0.rawValue })
        parameterBox.selectItem(at: 0)
    }

    // MARK: Loading
    
    private func loadReviews(completion: @escaping () -> Void) {
        currentPage += 1
        
        AppStore.current.getReviews(appID: .sberbankOnline, page: currentPage) { [unowned self] reviews in
            guard self.currentPage <= self.pagesCount, !reviews.isEmpty else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            self.reviews.append(contentsOf: reviews)
            self.loadReviews(completion: completion)
        }
    }
    
    // MARK: Actions
    
    @IBAction func nextReviewTapped(_ sender: Any) {
        guard
            let rawValue = parameterBox.itemObjectValue(at: parameterBox.indexOfSelectedItem) as? String,
            let team = Review.Team(rawValue: rawValue) else {
            return
        }
        
        reviews[currentReview].updateTeam(team)
        
        currentReview += 1
        showReview(for: currentReview)
    }
    
    @IBAction func saveDataSetTapped(_ sender: Any) {
    }
}

