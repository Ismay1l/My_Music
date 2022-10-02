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
import UIKit
import CoreData

class HomeVM {
    
    private let apiManager: APIManagerProtocol
    var browseModel = [Browse]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let dataStack = CoreDataStack(modelName: "BrowseModel")
    
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
                self.newReleasesRelay.accept(.showNewReleases(response))
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
                self.featuredPlaylistsRelay.accept(.showFeaturedPlaylists(response))
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
                        self.recommendationsRelay.accept(.showRecommendations(response))
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
    }
    
    //MARK: - Core Data
    private func saveContext() {
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func saveBrowse(artistTitle: String, albumTitle: String, image: String) {
        let newBrowse = Browse(context: context)
        newBrowse.artistTitle = artistTitle
        newBrowse.albumTitle = albumTitle
        newBrowse.image = image
        saveContext()
    }
    
    func getAllNotes() {
        do {
            browseModel = try context.fetch(Browse.fetchRequest())
            print(browseModel.count)
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>.init(entityName: "Browse")
        fetchRequest.resultType = .managedObjectResultType
        
        do {
            let ids = try dataStack.managedContext.fetch(fetchRequest)
            if ids.isEmpty {
                print("All deleted already")
                return
            }
            let batchDelete = NSBatchDeleteRequest(objectIDs: ids)
            batchDelete.resultType = .resultTypeCount
            
            let batchResult = try self.dataStack.managedContext.execute(batchDelete) as? NSBatchDeleteResult
            if let count = batchResult?.result as? Int {
                print("Deleted elements: \(count)")
            }
        } catch {
            print(error)
        }
    }
}

class CoreDataStack {
    
    private let modelName: String
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unsolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        guard self.managedContext.hasChanges else { return }
        do {
            try self.managedContext.save()
        } catch let error as NSError {
            print("Unsolved error \(error), \(error.userInfo)")
        }
    }
}
