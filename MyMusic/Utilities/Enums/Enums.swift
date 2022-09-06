//
//  Enums.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.09.22.
//

import Foundation

enum NewReleaseState {
    case showNewReleases(model: NewReleaseResponse)
}

enum FeaturedPlaylistState {
    case showFeaturedPlaylists(model: FeaturedPlaylistResponse)
}

enum RecommendationState {
    case showRecommendations(model: RecommendationsResponse)
}

enum UserProfileState {
    case showUserProfile(model: UserProfile)
}

enum AlbumDetailsState {
    case showAlbumDetails(model: AlbumDetailResponse)
}

enum PlaylistState {
    case showPlaylist(model: PlaylistResponse)
}
