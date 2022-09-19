//
//  LibraryVM.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 9/19/22.
//

import Foundation
import RxSwift
import RxRelay

class LibraryVM {
    
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
                self.userPlaylistRelay.accept(.showUserPlaylist(model: result))
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
}
