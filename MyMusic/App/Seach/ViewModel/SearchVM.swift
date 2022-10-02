//
//  SearchVM.swift
//  MyMusic
//
//  Created by USER11 on 9/9/22.
//

import Foundation
import RxRelay
import RxSwift
import CoreData
import UIKit

class SearchVM {
    
    //MARK: - Variables
    private let apiManager: APIManagerProtocol
    
    private let contextSearch = (UIApplication.shared.delegate as! AppDelegate).persistentContainerSearch.viewContext
    private let dataStackSearch = CoreDataStack(modelName: "SearchCategory")
    var localSearchCategory = [SearchCategory]()

    private let categoriesRelay = BehaviorRelay<CategoriesState?>.init(value: nil)
    private let searchResultRelay = BehaviorRelay<SearchResultState?>.init(value: nil)
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Fetch Categories
    func fetchCategories() -> Observable<CategoriesState> {
        apiManager.fetchCategories()
            .then { result in
                self.categoriesRelay.accept(.showCategories(result))
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
        apiManager.fetchSearchResult(query)
            .then { result in
                switch result {
                case .success(let model):
                    self.searchResultRelay.accept(.showSearchResult(model))
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
    
    //MARK: - Core Data
    private func saveContextSearch() {
        
        do {
            try contextSearch.save()
        } catch {
            print(error)
        }
    }
    
    //MARK: - Save Result
    func saveSearchCategory(icon: String, name: String) {
        let newCategory = SearchCategory(context: contextSearch)
        newCategory.name = name
        newCategory.icon = icon
        saveContextSearch()
    }
    
    //MARK: - Get Result
    func getAllCategories() {
        do {
            localSearchCategory = try contextSearch.fetch(SearchCategory.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    //MARK: - Delete Result
    func deleteAllCategories() {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>.init(entityName: "SearchCategory")
        fetchRequest.resultType = .managedObjectResultType
        
        do {
            let ids = try dataStackSearch.managedContext.fetch(fetchRequest)
            if ids.isEmpty {
                print("All deleted already")
                return
            }
            let batchDelete = NSBatchDeleteRequest(objectIDs: ids)
            batchDelete.resultType = .resultTypeCount
            
            let batchResult = try self.dataStackSearch.managedContext.execute(batchDelete) as? NSBatchDeleteResult
            if let count = batchResult?.result as? Int {
                print("Deleted elements: \(count)")
            }
        } catch {
            print(error)
        }
    }
}
