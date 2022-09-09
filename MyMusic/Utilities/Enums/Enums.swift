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

enum CategoriesState {
    case showCategories(model: CategoriesResponse)
}

enum CategoriesPlaylistState {
    case showCategoriesPlaylist(model: CategoriesPlaylistResponse)
}

enum MainCollectionViewHeaderType {
    case browse
    case featuredPlaylists
    case recommendedTracks
    
    var collectionViewHeaders: String {
        switch self {
        case MainCollectionViewHeaderType.browse:
            return L10n.browseTitle
        case MainCollectionViewHeaderType.featuredPlaylists:
            return L10n.featuredPlaylistsTitle
        case MainCollectionViewHeaderType.recommendedTracks:
            return L10n.recommendedTracksTitle
        }
    }
}
