//
//  LibraryPlaylistVM.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 24.09.22.
//

import Foundation
import RxRelay
import RxSwift

class LibraryPlaylistVM {
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Variables
    private let userPlaylistRelay = BehaviorRelay<CurrentUserPlaylistState?>.init(value: nil)
    
    //MARK: - Fetch Current User's Playlist
    func fetchCurrentUserPlaylist() -> Observable<CurrentUserPlaylistState> {
        apiManager.fetchCurrentUserPlaylist()
            .then { result in
                self.userPlaylistRelay.accept(.showUserPlaylist(result))
            }
        return userPlaylistRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
    
    //MARK: - Create A Playlist
    func createPlaylist(_ with: String, completion: @escaping (Bool) -> Void) {
        apiManager.createPlaylist(with: with) { success in
            if success {
                completion(success)
            }
        }
    }
}
