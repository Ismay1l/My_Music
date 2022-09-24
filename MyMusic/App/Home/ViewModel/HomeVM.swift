//
//  HomeVM.swift
//  MyMusic
//
//  Created by USER11 on 9/1/22.
//

import Foundation
import RxRelay
import RxSwift
import Promises

class HomeVM {
    
    private let apiManager: APIManagerProtocol
    
    init(manager: APIManagerProtocol = APIManager()) {
        self.apiManager = manager
    }
    
    //MARK: - Variables
    private let newReleasesRelay = BehaviorRelay<NewReleaseState?>.init(value: nil)
    private let featuredPlaylistsRelay = BehaviorRelay<FeaturedPlaylistState?>.init(value: nil)
    private let recommendationsRelay = BehaviorRelay<RecommendationState?>.init(value: nil)
    
    //MARK: - Fetch New Releases
    func fetchBrowseNewReleasesData() -> Observable<NewReleaseState> {
        apiManager.fetchBrowseNewReleases()
            .then { response in
                self.newReleasesRelay.accept(.showNewReleases(model: response))
            }
        return newReleasesRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
    
    //MARK: - Fetch Featured-Playlist
    func fetchFeaturedPlaylist() -> Observable<FeaturedPlaylistState> {
        apiManager.fetchFeaturedPlaylist()
            .then { response in
                self.featuredPlaylistsRelay.accept(.showFeaturedPlaylists(model: response))
            }
        return featuredPlaylistsRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
    
    //MARK: - Fetch Recommended Genres
    func fetchRecommendedGenres() -> Observable<RecommendationState> {
        apiManager.fetchRecommendedGenres()
            .then { response  in
                let genres = response.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let randomGenre = genres?.randomElement() {
                        seeds.insert(randomGenre)
                    }
                }
                
                //MARK: - Fetch Recommendations
                self.apiManager.fetchRecommendations(genres: seeds)
                    .then { response in
                        self.recommendationsRelay.accept(.showRecommendations(model: response))
                    }
            }
        return recommendationsRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
    
    //MARK: - Add Track To Playlist
    func addTrackToPlaylist(add track: Track, playlist: Item) -> Promise<Bool> {
        apiManager.addTrackToPlaylist(add: track, playlist: playlist)
            .then { success in
                print(success)
            }
    }
}
