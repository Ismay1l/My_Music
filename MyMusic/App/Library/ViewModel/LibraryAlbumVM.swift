//
//  LibraryAlbumVM.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 24.09.22.
//

import Foundation
import RxRelay
import RxSwift

class LibraryAlbumVM {
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Variables
    private let savedAlbumRelay = BehaviorRelay<SavedAlbumState?>.init(value: nil)
    
    //MARK: - Fetch Saved Albums
    func fetchSavedAlbums() -> Observable<SavedAlbumState> {
        apiManager.fetchSavedAlbums()
            .then { result in
                self.savedAlbumRelay.accept(.showSavedAlbum(result))
            }
        return savedAlbumRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
}
