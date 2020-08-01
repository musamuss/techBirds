//
//  AppInfo.swift
//  techBirds
//
//  Created by Artem Belkov on 01.08.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import Foundation

struct AppInfo {
    let name: String
    let rating: Double
    let reviewsCount: Int
}

extension AppInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case rating = "averageUserRating"
        case reviewsCount = "userRatingCountForCurrentVersion"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decode(Double.self, forKey: .rating)
        reviewsCount = try container.decode(Int.self, forKey: .reviewsCount)
    }
}

struct SearchResults: Decodable {
    let appsInfo: [AppInfo]
    let androidInfo: [AppInfo] = [AppInfo(name: "Sberbank", rating: 0, reviewsCount: 0)]
    
    enum CodingKeys: String, CodingKey {
        case appsInfo = "results"
        case androidInfo = "results1"
    }
}
