//
//  CurrentUerPlaylist.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 9/19/22.
//

import Foundation

// MARK: - CurrentUserPlaylistResponse
struct CurrentUserPlaylistResponse: Codable {
    let items: [Item]?
    let total: Int?
}
