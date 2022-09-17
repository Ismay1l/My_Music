//
//  SearchVM.swift
//  MyMusic
//
//  Created by USER11 on 9/9/22.
//

import Foundation
import RxRelay
import RxSwift

class SearchVM {
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Variables
    private let categoriesRelay = BehaviorRelay<CategoriesState?>.init(value: nil)
    private let searchResultRelay = BehaviorRelay<SearchResultState?>.init(value: nil)
    
    //MARK: - Fetch Categories
    func fetchCategories() -> Observable<CategoriesState> {
        apiManager.fetchCategories()
            .then { result in
                self.categoriesRelay.accept(.showCategories(model: result))
            }
        return categoriesRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
    
    //MARK: - Fetch Search Result
    func fetchSearchResult(query: String) -> Observable<SearchResultState> {
        apiManager.fetchSearchResult(query: query)
            .then { result in
                switch result {
                case .success(let model):
                    self.searchResultRelay.accept(.showSearchResult(model: model))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        return searchResultRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
}
