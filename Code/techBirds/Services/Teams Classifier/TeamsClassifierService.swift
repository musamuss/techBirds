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
            model = try TeamsClassifier(configuration: configuration).model
            predictor = try NLModel(mlModel: model)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func classify(_ review: Review) -> Review {
        var review = review
        
        if let rawTeam = predictor.predictedLabel(for: review.text),
           let team = Review.Team(rawValue: rawTeam) {
            review.updateTeam(team)
        }
                
        return review
    }
    
    private let model: MLModel
    private let predictor: NLModel
    
    private let configuration = MLModelConfiguration()
}
