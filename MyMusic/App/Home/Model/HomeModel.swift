//
//  HomeModel.swift
//  MyMusic
//
//  Created by USER11 on 9/1/22.
//

import Foundation

//MARK: - Browse New Releases
struct NewReleaseResponse: Codable {
    let albums: AlbumResponse?
}

struct AlbumResponse: Codable {
    let items: [Album]?
}

struct Album: Codable {
    let album_type: String?
    let artists: [Artist]?
    let available_markets: [String]?
    let id: String?
    let images: [APIImage]?
    let name: String?
    let release_date: String?
    let total_tracks: Int?
}

struct Artist: Codable {
    let id: String?
    let name: String?
    let type: String?
}

struct APIImage: Codable {
    let url: String?
}

//MARK: - Featured Playlist
struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistItem?
}

struct PlaylistItem: Codable {
    let items: [FeaturedPlaylistItem]?
}

struct FeaturedPlaylistItem: Codable {
    let description: String?
    let external_urls: [String: String]?
    let id: String?
    let images: [APIImage]?
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
    let seeds: [Seed]?
    let tracks: [AudioTrack]?
}

struct Seed: Codable {
    let id: String?
    let type: String?
}

struct AudioTrack: Codable {
    let album: Album?
    let artists: [Artist]?
    let available_markets: [String]?
    let disc_number: Int?
    let duration_ms: Int?
    let explicit: Bool?
    let external_urls: [String: String]?
    let id: String?
    let name: String?
    let popularity: Int?
}

//MARK: - Album Details
struct AlbumDetailResponse: Codable {
    let album_type: String?
    let artists: [Artist]?
    let available_markets: [String]?
    let copyrights: [Copyright]?
    let external_urls: [String: String]?
    let id: String?
    let images: [APIImage]?
    let label: String?
    let name: String?
    let release_date: String?
    let tracks: AlbumTrack?
}

struct Copyright: Codable {
    let text: String?
    let type: String?
}

struct AlbumTrack: Codable {
    let items: [TrackItem]?
}

struct TrackItem: Codable {
    let artists: [Artist]?
    let available_markets: [String]?
    let external_urls: [String: String]?
    let name: String?
    let id: String?
}

//MARK: - Playlists
struct PlaylistResponse: Codable {
    let external_urls: [String: String]?
    let id: String?
    let images: [APIImage]?
    let name: String?
    let owner: Owner?
    let primary_color: String?
    let tracks: PlaylistTrack?
}

struct PlaylistTrack: Codable {
    let items: [PlaylistTrackItem]?
}

struct PlaylistTrackItem: Codable {
    let added_at: String?
    let track: Track?
}

struct Track: Codable {
    let album: Album?
    let artists: [Artist]?
    let available_markets: [String]?
    let external_urls: [String: String]?
    let id: String?
    let name: String?
    let preview_url: String?
}

