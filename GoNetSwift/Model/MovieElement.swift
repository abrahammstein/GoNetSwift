//
//  MovieElement.swift
//  GoNet (iOS)
//
//  Created by Abraham Lopez on 3/14/22.
//


import Foundation

// MARK: - MovieElement
struct MovieElement: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let summary: String
    let image: MovieImage
    let externals: Externals

    enum CodingKeys: String, CodingKey {
        case  id, name, summary, image, externals
    }
}

// MARK: - Image
struct MovieImage: Codable, Hashable {
    let medium, original: String
}

// MARK: - Externals
struct Externals: Codable, Hashable {
    let tvrage, thetvdb: Int?
    let imdb: String?
}



typealias Movie = [MovieElement]
