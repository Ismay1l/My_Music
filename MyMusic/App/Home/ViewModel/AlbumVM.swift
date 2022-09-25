//
//  AlbumVM.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 04.09.22.
//

import Foundation
import RxRelay
import RxSwift
import Promises

class AlbumVM {
    
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Variables
    private let albumDetailsRelay = BehaviorRelay<AlbumDetailsState?>.init(value: nil)
    
    //MARK: - Fetch Album Details
    func fetchAlbumDetail(album: Album) -> Observable<AlbumDetailsState> {
        apiManager.fetchAlbumDetails(album)
            .then { response in
                self.albumDetailsRelay.accept(.showAlbumDetails(response))
            }
        return albumDetailsRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
    
    //MARK: - Save Album
    func saveAlbum(_ album: Album) -> Promise<Bool> {
        apiManager.saveAlbum(album)
    }
}
