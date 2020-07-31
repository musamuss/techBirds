//
//  Review.swift
//  techBirds
//
//  Created by Artem Belkov on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import Foundation

struct Review: Decodable {
    let author: String
    let rating: Int
    let title: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case rating = "im:rating"
        case title
        case content
    }

    enum AuthorContainerKeys: String, CodingKey {
        case uri
    }
    
    enum ContainerKeys: String, CodingKey {
        case label
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let authorContainer = try container.nestedContainer(keyedBy: AuthorContainerKeys.self, forKey: .author)
        let authorURIConstainer = try authorContainer.nestedContainer(keyedBy: ContainerKeys.self, forKey: .uri)
        author = try authorURIConstainer.decode(String.self, forKey: .label)

        let ratingContainer = try container.nestedContainer(keyedBy: ContainerKeys.self, forKey: .rating)
        let stringRating = try ratingContainer.decode(String.self, forKey: .label)
        rating = Int(stringRating) ?? 0
        
        let titleContainer = try container.nestedContainer(keyedBy: ContainerKeys.self, forKey: .title)
        title = try titleContainer.decode(String.self, forKey: .label)
        
        let contentContainer = try container.nestedContainer(keyedBy: ContainerKeys.self, forKey: .content)
        content = try contentContainer.decode(String.self, forKey: .label)
    }
}

struct ReviewsFeed: Decodable {
    let reviews: [Review]
    
    enum CodingKeys: String, CodingKey {
        case feed
    }

    enum ContainerKeys: String, CodingKey {
        case reviews = "entry"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let reviewsContainer = try container.nestedContainer(keyedBy: ContainerKeys.self, forKey: .feed)
        
        reviews = try reviewsContainer.decode([Review].self, forKey: .reviews)
    }
}
