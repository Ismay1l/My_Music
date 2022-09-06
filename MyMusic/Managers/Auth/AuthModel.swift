//
//  AuthResponse.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 26.08.22.
//

import Foundation

struct AuthResponse: Decodable {
    let accessToken, tokenType: String?
    let expiresIn: Int?
    let refreshToken, scope: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }
}

struct AccessCredentials {
    static let clientID = "c92274e3244543d2b3889a836f61697a"
    static let clientSecret = "c1ed022ee0d54cca88b045c536a57a9c"
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    static let redirectURI = "https://www.iosacademy.io"
    static let scopes = "user-read-private%20user-read-recently-played%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read"
}
