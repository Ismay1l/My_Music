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
    func fetchPlaylists(playlist: Item) -> Promise<PlaylistResponse>
    func fetchCategories() -> Promise<CategoriesResponse>
    func fetchCategoriesPlaylist(item: CategoryItem) -> Promise<CategoriesPlaylistResponse>
}

protocol PlaylistHeaderCollectionViewDelegate: AnyObject {
    func didTapPlayButton(_ header: PlaylistHeaderCollectionView)
}

protocol BrowseAlbumsHeaderViewDelegate: AnyObject {
    func didTapPlayButton(_ header: BrowseAlbumsHeaderView)
}

protocol TrackControllerViewDelegate: AnyObject {
    func didTapPlayButton(_ playerController: TrackControllerView)
    func didTapBackButton(_ playerController: TrackControllerView)
    func didTapForwardButton(_ playerController: TrackControllerView)
}

protocol PlayerVCDataSource: AnyObject {
    var trackName: String? { get }
    var artistName: String? { get }
    var imageURL: URL? { get }
}
