//
//  Protocols.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 04.09.22.
//

import Foundation
import Promises

protocol APIManagerProtocol {
    func fetchUserProfile() -> Promise<UserProfile>
    func fetchBrowseNewReleases() -> Promise<NewReleaseResponse>
    func fetchFeaturedPlaylist() -> Promise<FeaturedPlaylistResponse>
    func fetchRecommendedGenres() -> Promise<RecommendedGenreResponse>
    func fetchRecommendations(genres: Set<String>) -> Promise<RecommendationsResponse>
    func fetchAlbumDetails(album: Album) -> Promise<AlbumDetailResponse>
    func fetchPlaylists(playlist: FeaturedPlaylistItem) -> Promise<PlaylistResponse>
    func fetchCategories() -> Promise<CategoriesResponse>
}

protocol PlaylistHeaderCollectionViewDelegate: AnyObject {
    func didTapPlayButton(_ header: PlaylistHeaderCollectionView)
}

protocol BrowseAlbumsHeaderViewDelegate: AnyObject {
    func didTapPlayButton(_ header: BrowseAlbumsHeaderView)
}
