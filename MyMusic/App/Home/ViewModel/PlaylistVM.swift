//
//  PlaylistVM.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 05.09.22.
//

import Foundation
import RxRelay
import RxSwift
import Promises

class PlaylistVM {
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Variables
    private let playlistRelay = BehaviorRelay<PlaylistState?>.init(value: nil)
    
    //MARK: - Fetch Playlists
    func fetchPlaylists(playlist: Item) -> Observable<PlaylistState> {
        apiManager.fetchPlaylists(playlist)
            .then { response in
                self.playlistRelay.accept(.showPlaylist(response))
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
    
    //MARK: - Remove Track From Playlist
    func removeTrackFromPlaylist(add track: PlaylistItem, playlist: Item) -> Promise<Bool> {
        apiManager.removeTrackFromPlaylist(remove: track, playlist: playlist)
    }
}
