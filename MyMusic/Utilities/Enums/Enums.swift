//
//  Enums.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.09.22.
//

import Foundation

enum NewReleaseState {
    case showNewReleases(_ model: NewReleaseResponse)
}

enum FeaturedPlaylistState {
    case showFeaturedPlaylists(_ model: FeaturedPlaylistResponse)
}

enum RecommendationState {
    case showRecommendations(_ model: RecommendationsResponse)
}

enum UserProfileState {
    case showUserProfile(_ model: UserProfileResponse)
}

enum AlbumDetailsState {
    case showAlbumDetails(_ model: AlbumDetailResponse)
}

enum PlaylistState {
    case showPlaylist(_ model: PlaylistResponse)
}

enum CategoriesState {
    case showCategories(_ model: CategoriesResponse)
}

enum CategoriesPlaylistState {
    case showCategoriesPlaylist(_ model: CategoriesPlaylistResponse)
}

enum SearchResultState {
    case showSearchResult(_ model: [SearchResult])
}

enum CurrentUserPlaylistState {
    case showUserPlaylist(_ model: CurrentUserPlaylistResponse)
}

enum SavedAlbumState {
    case showSavedAlbum(_ model: SavedAlbumResponse)
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

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: Track)
    case playlist(model: Item)
}

enum SwitchLibraryVCState {
    case playlist
    case album
}
