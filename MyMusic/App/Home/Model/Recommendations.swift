//
//  Recommendations.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import Foundation

//MARK: - Recommendations
struct RecommendationsResponse: Codable {
    let tracks: [Track]?
    let seeds: [Seed]?
}

struct Seed: Codable {
    let id: String?
}

struct Track: Codable {
    var album: Album?
    let artists: [Artist]?
    let available_markets: [String]?
    let external_urls: ExternalUrls?
    let id: String?
    let name: String?
    let preview_url: String?
    let trackNumber: Int?
}
