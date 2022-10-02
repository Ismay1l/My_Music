//
//  Section.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 28.08.22.
//

import Foundation

//MARK: User
struct UserProfileResponse: Codable {
    let country, displayName: String?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let id, product, type: String?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case followers, id, product, type, images
    }
}
