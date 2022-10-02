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








