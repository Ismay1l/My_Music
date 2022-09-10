//
//  SearchModel.swift
//  MyMusic
//
//  Created by USER11 on 9/9/22.
//

import Foundation

//MARK: - Categories
struct CategoriesResponse: Codable {
    let categories: Categories?
}

struct Categories: Codable {
    let items: [CategoryItem]?
}

struct CategoryItem: Codable {
    let href: String?
    let icons: [Image]?
    let id, name: String?
}

//MARK: - Category's Playlist
struct CategoriesPlaylistResponse: Codable {
    let playlists: Playlists?
}
