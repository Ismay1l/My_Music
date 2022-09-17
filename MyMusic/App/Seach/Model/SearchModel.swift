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

//MARK: - Search Result
struct SearchResultResponse: Codable {
    let albums: SearchAlbum?
    let artists: SearchArtist?
    let tracks: SearchTrack?
    let playlists: SearchPlaylist?
}

struct SearchAlbum: Codable {
    let items: [Album]?
}

struct SearchArtist: Codable {
    let items: [Artist]?
}

struct SearchPlaylist: Codable {
    let items: [Item]?
}

struct SearchTrack: Codable {
    let items: [Track]?
}

//MARK: - SearchResult TableView Model
struct SearchSection {
    let title: String?
    let results: [SearchResult]?
}

//MARK: - SearchResult Artist TableView Model
struct SearchResultArtistTableViewModel {
    let title: String?
    let imageURL: URL?
}

//MARK: - SearchResult Album TableView Model
struct SearchResultAlbumTableViewModel {
    let title: String?
    let subtitle: String?
    let imageURL: URL?
}
