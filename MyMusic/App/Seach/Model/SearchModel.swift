//
//  SearchModel.swift
//  MyMusic
//
//  Created by USER11 on 9/9/22.
//

import Foundation

//MARK: - Categpries
struct CategoriesResponse: Codable {
    let categories: SearchCategory?
}

struct SearchCategory: Codable {
    let items: [CategoryItems]?
}

struct CategoryItems: Codable {
    let href: String?
    let icons: [APIImage]?
    let id: String?
    let name: String?
}

//MARK: - Category's Playlist
struct CategoriesPlaylistResponse: Codable {
    let playlists: CategoryPlaylist?
}

struct CategoryPlaylist: Codable {
    let items: [CategoriesPlaylistItem]?
}

struct CategoriesPlaylistItem: Codable {
    let description: String?
    let external_urls: [String: String]?
    let id: String?
    let images: [APIImage]?
    let name: String?
    let owner: Owner?
    let tracks: CategoriesPlaylistTracks?
}

struct CategoriesPlaylistTracks: Codable {
    let total: Int?
}
