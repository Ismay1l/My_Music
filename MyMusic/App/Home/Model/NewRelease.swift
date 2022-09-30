//
//  HomeModel.swift
//  MyMusic
//
//  Created by USER11 on 9/1/22.
//

import Foundation
import RealmSwift

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
    let images: [Image]?
}

struct ExternalUrls: Codable {
    let spotify: String?
}

struct Image: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}

//MARK: - Realm Database
class NewReleaseResponseR: Object {
    @Persisted var albums: AlbumsR?
}

class AlbumsR: Object {
    @Persisted var items: List<AlbumR>
}

class AlbumR: Object {
//    @Persisted var artists: List<ArtistR>
    @Persisted var available_markets: List<String>
//    @Persisted var external_urls: ExternalUrlsR
    @Persisted var id: String
//    @Persisted var images: List<ImageR>
    @Persisted var name: String
    @Persisted var release_date: String?
    @Persisted var total_tracks: Int
}

//class ArtistR: Object {
//    @Persisted var external_urls: ExternalUrlsR
//    @Persisted var id: String
//    @Persisted var name: String
//    @Persisted var images: List<ImageR>
//}
//
//class ExternalUrlsR: Object {
//    @Persisted var spotify: String
//}
//
//class ImageR: Object {
//    @Persisted var height: Int
//    @Persisted var url: String
//    @Persisted var width: Int
//}








