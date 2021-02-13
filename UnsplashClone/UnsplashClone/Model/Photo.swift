//
//  Photo.swift
//  UnsplashClone
//
//  Created by 박성민 on 2021/02/13.
//

import Foundation

class Photo: Codable {
    let id: String
    let photoURLs: PhotoURLs
    let username: String
    let width: Int
    let height: Int
    let sponsered: Bool
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        photoURLs = try container.decode(PhotoURLs.self, forKey: .photoURLs)
        username = try container.decode(User.self, forKey: .username).name
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        sponsered = try !container.decodeNil(forKey: .sponsered)
        
    }
}

private extension Photo {
    enum Codingkeys: String, CodingKey {
        case id
        case photoURLs = "urls"
        case username = "name"
        case width
        case height
        case sponsered = "sponsership"
    }
}
