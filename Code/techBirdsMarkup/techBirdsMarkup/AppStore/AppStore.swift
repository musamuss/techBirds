//
//  AppStore.swift
//  techBirdsMarkup
//
//  Created by Artem Belkov on 31.07.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

class AppStore {
    static let current = AppStore()
    
    func getReviews(appID: AppID, page: Int, completion: @escaping ([Review]) -> Void) {
        if appID == .sberbankOnline {
            let startIndex = page * 50
            let lastIndex = startIndex + 50
            
            let reviews = additionalReviews[startIndex...lastIndex]
            completion(Array(reviews))
            return
        }
        guard page > 0 else { fatalError("Page can't be negative") }

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
}

private var additionalReviews: [Review] = {
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

enum AppID: Int {
    case sberbankOnline = 492224193
}

extension AppStore {
    enum Result<Model: Decodable> {
        case success(Model)
        case failure(Error)
    }

    enum RequestType {
        case get
        case post
    }
}
