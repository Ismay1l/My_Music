//
//  FeaturedPlaylist.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import Foundation

//MARK: - Featured Playlist
struct FeaturedPlaylistResponse: Codable {
    let playlists: Playlists?
}

struct Playlists: Codable {
    let items: [Item]?
}

struct Item: Codable {
    let description: String?
    let external_urls: ExternalUrls?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: Owner?
}

struct Owner: Codable {
    let display_name: String?
    let external_urls: [String: String]?
    let id: String?
}
