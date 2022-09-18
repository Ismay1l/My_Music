//
//  SearchResult.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 18.09.22.
//

import Foundation

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
