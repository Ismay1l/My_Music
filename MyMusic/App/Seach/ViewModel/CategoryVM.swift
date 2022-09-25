//
//  CategoryVM.swift
//  MyMusic
//
//  Created by USER11 on 9/9/22.
//

import Foundation
import RxSwift
import RxRelay

class CategoryVM {
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Variables
    private let categoriesPlaylistRelay = BehaviorRelay<CategoriesPlaylistState?>.init(value: nil)
    
    //MARK: - Fetch Category's Playlist
    func fetchCategoriesPlaylist(item: CategoryItem) -> Observable<CategoriesPlaylistState> {
        apiManager.fetchCategoriesPlaylist(item)
            .then { result in
                self.categoriesPlaylistRelay.accept(.showCategoriesPlaylist(result))
            }
        return categoriesPlaylistRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
}
