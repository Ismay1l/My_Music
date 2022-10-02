//
//  Protocols.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 04.09.22.
//

import Foundation
import Promises
import UIKit

protocol APIManagerProtocol {
    func fetchUserProfile() -> Promise<UserProfileResponse>
    func fetchBrowseNewReleases() -> Promise<NewReleaseResponse>
    func fetchFeaturedPlaylist() -> Promise<FeaturedPlaylistResponse>
    func fetchRecommendedGenres() -> Promise<RecommendedGenreResponse>
    func fetchRecommendations(genres: Set<String>) -> Promise<RecommendationsResponse>
    func fetchAlbumDetails(_ album: Album) -> Promise<AlbumDetailResponse>
    func fetchPlaylists(_ playlist: Item) -> Promise<PlaylistResponse>
    func fetchCategories() -> Promise<CategoriesResponse>
    func fetchCategoriesPlaylist(_ item: CategoryItem) -> Promise<CategoriesPlaylistResponse>
    func fetchSearchResult(_ query: String) -> Promise<Result<[SearchResult], Error>>
    func fetchCurrentUserPlaylist() -> Promise<CurrentUserPlaylistResponse>
    func createPlaylist(with name: String, completion: @escaping (Bool) -> Void)
    func addTrackToPlaylist(add track: Track, playlist: Item) -> Promise<Bool>
    func removeTrackFromPlaylist(remove track: PlaylistItem, playlist: Item) -> Promise<Bool>
    func fetchSavedAlbums() -> Promise<SavedAlbumResponse>
    func saveAlbum(_ album: Album) -> Promise<Bool>
}

protocol TrackControllerViewDelegate: AnyObject {
    func didTapPlayButton(_ playerController: TrackControllerView)
    func didTapBackButton(_ playerController: TrackControllerView)
    func didTapForwardButton(_ playerController: TrackControllerView)
    func didChangeSliderValue(_ playerController: TrackControllerView, value: Float)
}

protocol PlayerVCDataSource: AnyObject {
    var trackName: String? { get }
    var artistName: String? { get }
    var imageURL: URL? { get }
}

protocol PlayerVCDelegate: AnyObject {
    func didTapPlay()
    func didTapBack()
    func didTapForward()
    func didChangeSliderValue(_ value: Float)
    func isDismissed()
}

protocol SearchResultVCDelegate: AnyObject {
    func didSelectOption(_ result: SearchResult)
}
