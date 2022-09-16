//
//  HomeModel.swift
//  MyMusic
//
//  Created by USER11 on 9/1/22.
//

import Foundation

//MARK: - Browse New Releases
struct NewReleaseResponse: Codable {
    let albums: Albums?
}

struct Albums: Codable {
    let items: [Album]?
}

struct Album: Codable {
    let artists: [Artist]?
    let available_markets: [String]?
    let external_urls: ExternalUrls?
    let id: String?
    var images: [Image]?
    let name, release_date: String?
    let total_tracks: Int?
}

struct Artist: Codable {
    let external_urls: ExternalUrls?
    let id, name: String?
}

struct ExternalUrls: Codable {
    let spotify: String?
}

struct Image: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}

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

//MARK: - Recommended Genres
struct RecommendedGenreResponse: Codable {
    let genres: [String]?
}

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

