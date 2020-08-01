//
//  AppStoreService.swift
//  techBirds
//
//  Created by Artem Belkov on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import Foundation

class AppStoreService {
    
    func getAppInfo(appID: AppID, completion: @escaping (AppInfo) -> Void) {
        let url = appInfoEndpoint(appID: appID)
        
        makeGetRequest(url: url, modelType: SearchResults.self) { result in
            if case .success(let results) = result {
                if appID == .sberbankOnlineAndroid {
                    completion(results.androidInfo.first!)
                } else {
                    completion(results.appsInfo.first!)
                }
            }
        }
    }
    
    func getReviews(appID: AppID, page: Int, completion: @escaping ([Review]) -> Void) {
        guard page > 0 else {
            completion([])
            return
        }
        if appID == .sberbankOnlineAndroid {
            let startIndex = page * 50
            let lastIndex = startIndex + 50

            let reviews = additionalReviews[startIndex...lastIndex]
            completion(Array(reviews))
            return
        }
        
        guard page < 10 else {
            let startIndex = (page - 10) * 50
            let lastIndex = startIndex + 50

            let reviews = additionalReviews[startIndex...lastIndex]
            completion(Array(reviews))
            return
        }
        
        let url = reviewsEndpoint(appID: appID, page: page)
        
        makeGetRequest(url: url, modelType: ReviewsFeed.self) { result in
            if case .success(let feed) = result {
                completion(feed.reviews)
            }
        }
    }
    
    // MARK: Private
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    // MARK: Endpoints
    
    private func appInfoEndpoint(appID: AppID) -> URL {
        let path = "https://itunes.apple.com/lookup?id=\(appID.rawValue)"
        return URL(string: path)!
    }
    
    private func reviewsEndpoint(appID: AppID, page: Int) -> URL {
        let path = "https://itunes.apple.com/ru/rss/customerreviews/page=\(page)/id=\(appID.rawValue)/sortBy=mostRecent/json"
        return URL(string: path)!
    }
    
    // MARK: Requests
    
    private func makeRequest<Model: Decodable>(_ type: RequestType, modelType: Model.Type, url: URL, completion: @escaping (Result<Model>) -> Void) {
        switch type {
        case .get:
            makeGetRequest(url: url, modelType: modelType, completion: completion)
        case .post:
            fatalError("Not implemented")
        }
    }
    
    private func makeGetRequest<Model: Decodable>(url: URL, modelType: Model.Type, completion: @escaping (Result<Model>) -> Void) {
        let task = session.dataTask(with: url) { [unowned self] data, response, error in
            if let error = error, data == nil {
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            
            do {
                let model = try self.decoder.decode(Model.self, from: data)
                completion(.success(model))
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    // MARK: Additional data
    
    private lazy var additionalReviews: [Review] = {
        guard let path = Bundle.main.path(forResource: "reviews_data", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let rawReviews = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return []
        }
        
        let reviews: [Review] = rawReviews.compactMap { raw in
            guard
                let author = raw["author"] as? String,
                let ratingString = raw["rating"] as? String,
                let rating = Int(ratingString),
                let title = raw["title"] as? String,
                let content = raw["content"] as? String else {
                return nil
            }

            return .init(
                author: author,
                rating: rating,
                title: title,
                content: content
            )
        }
        
        return reviews
    }()
    
    private lazy var additionalAndroidReviews: [Review] = {
        guard let path = Bundle.main.path(forResource: "reviews_data", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let rawReviews = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
            return []
        }
        
        let reviews: [Review] = rawReviews.compactMap { raw in
            guard
                let author = raw["author"] as? String,
                let ratingString = raw["rating"] as? String,
                let rating = Int(ratingString),
                let title = raw["title"] as? String,
                let content = raw["content"] as? String else {
                return nil
            }

            return .init(
                author: author,
                rating: rating,
                title: title,
                content: content
            )
        }
        
        return reviews
    }()
}

enum AppID: Int {
    case sberbankOnline = 492224193
    case sberbankOnlineAndroid = 0
    case sberKazahstan = 993084220
    case sberBelorus = 1382598666
}

extension AppStoreService {
    enum Result<Model: Decodable> {
        case success(Model)
        case failure(Error)
    }
    
    enum RequestType {
        case get
        case post
    }
}
