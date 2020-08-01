//
//  ClassifierService.swift
//  techBirds
//
//  Created by Artem Belkov on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import NaturalLanguage
import CoreML

class CategoriesClassifierService {
        
    init() {
        do {
            model = try CategoriesClassifier(configuration: MLModelConfiguration()).model
            predictor = try NLModel(mlModel: model)
        } catch {
            fatalError("Эррор чувачки!!")
        }
    }
    
    func classify(_ reviewText: String) -> String? {
        return predictor.predictedLabel(for: reviewText)
    }
    
    private let model: MLModel
    private let predictor: NLModel
}
