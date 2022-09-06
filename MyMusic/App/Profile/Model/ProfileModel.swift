//
//  Section.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 28.08.22.
//

import Foundation

//MARK: SettingsVC TableView Model
struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}

//MARK: User
struct UserProfile: Codable {
    let country, displayName: String?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let id, product, type: String?
    let images: [UserImage]?

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case followers, id, product, type, images
    }
}

struct ExternalUrls: Codable {
    let spotify: String?
}

struct Followers: Codable {
    let href: String?
    let total: Int?
}

struct UserImage: Codable {
    let url: String?
}
