//
//  TeamsClassifierService.swift
//  techBirds
//
//  Created by Artem Belkov on 01.08.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import NaturalLanguage
import CoreML

class TeamsClassifierService {
        
    init() {
        do {
            classifier = try TeamsClassifier(configuration: configuration)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func classify(_ review: Review) -> Review {
        var review = review
        
        do {
            let prefiction = try classifier.prediction(review: makeWordsFeatures(review.text))
            print(prefiction.teamProbability)
            
            if let team = Review.Team(rawValue: prefiction.team) {
                review.updateTeam(team)
            }
                        
        } catch let error {
            fatalError(error.localizedDescription)
        }
              
        return review
    }
    
    private let classifier: TeamsClassifier
    private let configuration = MLModelConfiguration()
}
