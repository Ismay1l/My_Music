//
//  Playlists.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import Foundation

//MARK: - Playlists
struct PlaylistResponse: Codable {
    let images: [Image]?
    let name: String?
    let owner: Owner?
    let tracks: PlaylistTrack?
    let external_urls: [String: String]?
    let id: String?
}

struct Followers: Codable {
    let href: String?
    let total: Int?
}

struct PlaylistTrack: Codable {
    let items: [PlaylistItem]?
}

struct PlaylistItem: Codable {
    let added_at: String?
    let track: Track?
}
