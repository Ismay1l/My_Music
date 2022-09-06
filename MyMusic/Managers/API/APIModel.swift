//
//  UserProfileModel.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import Foundation

struct APIConstants {
    static let baseURL = "https://api.spotify.com/v1"
}

enum APIError: Error {
    case failedToGetData
}
