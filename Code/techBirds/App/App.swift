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
    
    // Services
    let appStore = AppStoreService()
    
    // Classifiers
    let categoriesClassifier = CategoriesClassifierService()
    let teamsClassifier = TeamsClassifierService()
}
