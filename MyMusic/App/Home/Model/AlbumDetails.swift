//
//  AlbumDetails.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import Foundation

//MARK: - Album Details
struct AlbumDetailResponse: Codable {
    let artists: [Artist]?
    let available_markets: [String]?
    let external_urls: ExternalUrls?
    let id: String?
    let images: [Image]?
    let label, name: String?
    let release_date: String?
    let total_tracks: Int?
    let tracks: Tracks?
}

struct Tracks: Codable {
    let items: [Track]?
}
