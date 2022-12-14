//
//  PlaylistVM.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 05.09.22.
//

import Foundation
import RxRelay
import RxSwift

class PlaylistVM {
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Variables
    private let playlistRelay = BehaviorRelay<PlaylistState?>.init(value: nil)
    
    //MARK: - Fetch Playlists
    func fetchPlaylists(playlist: FeaturedPlaylistItem) -> Observable<PlaylistState> {
        apiManager.fetchPlaylists(playlist: playlist)
            .then { response in
                self.playlistRelay.accept(.showPlaylist(model: response))
            }
        return playlistRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
}
