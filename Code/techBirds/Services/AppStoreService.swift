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
                completion(results.appsInfo.first!)
            }
        }
    }
    
    func getReviews(appID: AppID, page: Int, completion: @escaping ([Review]) -> Void) {
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
}

enum AppID: Int {
    case sberbankOnline = 492224193
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
