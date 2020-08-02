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
            classifier = try CategoriesClassifier(configuration: configuration)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func classify(_ review: Review) -> Review {
        var review = review
                
        do {
            let prefiction = try classifier.prediction(review: makeWordsFeatures(review.text))
            print(prefiction.categoryProbability)
            
            if let category = Review.Category(rawValue: prefiction.category) {
                review.updateCategory(category, propability: prefiction.categoryProbability)
            }
                        
        } catch let error {
            fatalError(error.localizedDescription)
        }

        return review
    }
    
    func classifyText(_ text: String) -> [String:Double] {
                
        do {
            let prefiction = try classifier.prediction(review: makeWordsFeatures(text))
            
            return prefiction.categoryProbability
                        
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private let classifier: CategoriesClassifier
    private let configuration = MLModelConfiguration()
}

func makeWordsFeatures(_ text: String) -> [String: Double] {
    var bagOfWords = [String: Double]()

    let tagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
    let range = NSRange(location: 0, length: text.utf16.count)
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
    tagger.string = text.lowercased()

    tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _, tokenRange, _ in
        let word = (text as NSString).substring(with: tokenRange)
        if bagOfWords[word] != nil {
            bagOfWords[word]! += 1
        } else {
            bagOfWords[word] = 1
        }
    }

    return bagOfWords
}
