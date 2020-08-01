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
    
    @IBOutlet weak var teamBox: NSComboBox!
    @IBOutlet weak var categoryBox: NSComboBox!
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    private let reviewsCount = 100
    private let reviewsPerPage = 50
    private var pagesCount: Int { reviewsCount / reviewsPerPage }
    
    private let categoryName = "category_dataset.json"
    private let teamName = "team_dataset.json"

    private let encoder = JSONEncoder()
    
    private var currentPage = 0
    private var reviews: [Review] = []
    
    private var currentReview = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryBox.removeAllItems()
        teamBox.removeAllItems()
            
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
        reviewField.stringValue = review.text

        categoryBox.addItems(withObjectValues: Review.Category.all.map { $0.rawValue })
        categoryBox.selectItem(at: 0)
        
        teamBox.addItems(withObjectValues: Review.Team.all.map { $0.rawValue })
        teamBox.selectItem(at: 0)
    }
    
    private func saveMarkups(_ markups: [Review.Markup], for name: String) {
        do {
            guard let url = try? FileManager.default.url(
                for: .downloadsDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent(name) else {
                return
            }
            
            let data = try encoder.encode(markups)
            try data.write(to: url)
        } catch let error {
            fatalError(error.localizedDescription)
        }
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
        if let rawValue = teamBox.itemObjectValue(at: teamBox.indexOfSelectedItem) as? String,
           let team = Review.Team(rawValue: rawValue) {
            reviews[currentReview].updateTeam(team)
        }
        
        if let rawValue = categoryBox.itemObjectValue(at: categoryBox.indexOfSelectedItem) as? String,
           let category = Review.Category(rawValue: rawValue) {
            reviews[currentReview].updateCategory(category)
        }
                
        currentReview += 1
        showReview(for: currentReview)
    }
    
    @IBAction func saveDataSetTapped(_ sender: Any) {
        let filteredCategories = reviews
            .filter { $0.category != .undefined }
            .map { $0.categoryMarkup }
        saveMarkups(filteredCategories, for: categoryName)
        
        let filteredTeams = reviews
            .filter { $0.team != .undefined }
            .map { $0.teamMarkup }
        saveMarkups(filteredTeams, for: teamName)
    }
}

