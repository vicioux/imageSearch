//
//  ImageBase.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/26/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import Foundation

public struct ImageBase: Codable {
    public let title: String?
    public let description: String?
    public let link: URL?
    public let width: Float?
    public let height: Float?
    
    public var aspectRatio: Float? {
        guard let height = height, let width = width else { return 0 }
        return width / height
    }
    
    internal enum CodingKeys: String, CodingKey {
        case title
        case description
        case link
        case width
        case height
    }
}

public struct GalleryItem: Codable {
    public let title: String?
    public let description: String?
    public let images: [ImageBase]?
    
    internal enum CodingKeys: String, CodingKey {
        case title
        case description
        case images
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.images = try container.decodeIfPresent([ImageBase].self, forKey: .images)
    }
}

public struct SearchResponse: Codable {
     public let data: [GalleryItem]?
}
