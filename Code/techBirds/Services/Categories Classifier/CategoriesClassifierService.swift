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
            model = try CategoriesClassifier(configuration: configuration).model
            predictor = try NLModel(mlModel: model)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func classify(_ review: Review) -> Review {
        var review = review
        
        if let rawCategory = predictor.predictedLabel(for: review.text),
           let category = Review.Category(rawValue: rawCategory) {
            review.updateCategory(category)
        }
                
        return review
    }
    
    private let model: MLModel
    private let predictor: NLModel
    
    private let configuration = MLModelConfiguration()
}
