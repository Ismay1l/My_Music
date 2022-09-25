//
//  SavedAlbum.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.09.22.
//

import Foundation

// MARK: - SavedAlbumResponse
struct SavedAlbumResponse: Codable {
    let items: [SavedAlbumResponseItem]?
}

// MARK: - SavedAlbumResponseItem
struct SavedAlbumResponseItem: Codable {
    let album: SavedAlbum?
}

// MARK: - Album
struct SavedAlbum: Codable {
    let artists: [Artist]?
    let available_markets: [String]?
    let external_urls: ExternalUrls?
    let id: String?
    let images: [Image]?
    let name: String?
    let release_date: String?
    let total_tracks: Int?
    let tracks: Tracks?
}
