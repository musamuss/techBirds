//
//  App.swift
//  techBirds
//
//  Created by Artem Belkov on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import Foundation

class App {
    static let current = App()
    
    // Config
    private(set) var selectedTeam: Team = .undefined
    
    // Services
    let appStore = AppStoreService()
    
    // Classifiers
    let categoriesClassifier = CategoriesClassifierService()
    let teamsClassifier = TeamsClassifierService()
    
    // MARK: Methods
    
    func updateTeam(_ team: Team) {
        self.selectedTeam = team
    }
}

typealias Team = Review.Team
