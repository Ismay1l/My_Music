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
import Network

class HomeVM {
    
    //MARK: - Variables
    private let apiManager: APIManagerProtocol
    
    private let contextBrowse = (UIApplication.shared.delegate as! AppDelegate).persistentContainerBrowse.viewContext
    private let contextFeaturedPl = (UIApplication.shared.delegate as! AppDelegate).persistentContainerFeaturedPl.viewContext
    private let contextTrack = (UIApplication.shared.delegate as! AppDelegate).persistentContainerTrack.viewContext
    
    private let dataStackBrowse = CoreDataStack(modelName: "BrowseModel")
    private let dataStackFeaturedPl = CoreDataStack(modelName: "FeaturedPlModel")
    private let dataStackTrack = CoreDataStack(modelName: "TrackModel")
    
    var localNewReleases = [Browse]()
    var localFeaturedPl = [FeaturedPl]()
    var localTrack = [TrackEntity]()
    
    private let newReleasesRelay = BehaviorRelay<NewReleaseState?>.init(value: nil)
    private let featuredPlaylistsRelay = BehaviorRelay<FeaturedPlaylistState?>.init(value: nil)
    private let recommendationsRelay = BehaviorRelay<RecommendationState?>.init(value: nil)
    
    init(manager: APIManagerProtocol = APIManager()) {
        self.apiManager = manager
    }
    
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
    private func saveContextBrowse() {
        
        do {
            try contextBrowse.save()
        } catch {
            print(error)
        }
    }
    
    private func saveContextFeaturedPl () {
        
        do {
            try contextFeaturedPl.save()
        } catch {
            print(error)
        }
    }
    
    private func saveContextTrack () {
        
        do {
            try contextTrack.save()
        } catch {
            print(error)
        }
    }
    
    //MARK: - Save Result
    func saveBrowse(artistTitle: String, albumTitle: String, image: String) {
        let newBrowse = Browse(context: contextBrowse)
        newBrowse.artistTitle = artistTitle
        newBrowse.albumTitle = albumTitle
        newBrowse.image = image
        saveContextBrowse()
    }
    
    func saveFeaturedPl(image: String, title: String) {
        let newFeaturedPl = FeaturedPl(context: contextFeaturedPl)
        newFeaturedPl.image = image
        newFeaturedPl.title = title
        saveContextFeaturedPl()
    }
    
    func saveTrack(artist: String, title: String, image: String) {
        let newTrack = TrackEntity(context: contextTrack)
        newTrack.title = title
        newTrack.artist = artist
        newTrack.image = image
        saveContextTrack()
    }
    
    //MARK: - Get Result
    func getAllBrowse() {
        do {
            localNewReleases = try contextBrowse.fetch(Browse.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func getAllFeaturedPl() {
        do {
            localFeaturedPl = try contextFeaturedPl.fetch(FeaturedPl.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func getAllTrack() {
        do {
            localTrack = try contextTrack.fetch(TrackEntity.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    //MARK: - Delete Result
    func deleteAllBrowse() {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>.init(entityName: "Browse")
        fetchRequest.resultType = .managedObjectResultType
        
        do {
            let ids = try dataStackBrowse.managedContext.fetch(fetchRequest)
            if ids.isEmpty {
                print("All deleted already")
                return
            }
            let batchDelete = NSBatchDeleteRequest(objectIDs: ids)
            batchDelete.resultType = .resultTypeCount
            
            let batchResult = try self.dataStackBrowse.managedContext.execute(batchDelete) as? NSBatchDeleteResult
            if let count = batchResult?.result as? Int {
                print("Deleted elements: \(count)")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllFeaturedPl() {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>.init(entityName: "FeaturedPl")
        fetchRequest.resultType = .managedObjectResultType
        
        do {
            let ids = try dataStackFeaturedPl.managedContext.fetch(fetchRequest)
            if ids.isEmpty {
                print("All deleted already")
                return
            }
            let batchDelete = NSBatchDeleteRequest(objectIDs: ids)
            batchDelete.resultType = .resultTypeCount
            
            let batchResult = try self.dataStackFeaturedPl.managedContext.execute(batchDelete) as? NSBatchDeleteResult
            if let count = batchResult?.result as? Int {
                print("Deleted elements: \(count)")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllTrack() {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>.init(entityName: "TrackEntity")
        fetchRequest.resultType = .managedObjectResultType
        
        do {
            let ids = try dataStackTrack.managedContext.fetch(fetchRequest)
            if ids.isEmpty {
                print("All deleted already")
                return
            }
            let batchDelete = NSBatchDeleteRequest(objectIDs: ids)
            batchDelete.resultType = .resultTypeCount
            
            let batchResult = try self.dataStackTrack.managedContext.execute(batchDelete) as? NSBatchDeleteResult
            if let count = batchResult?.result as? Int {
                print("Deleted elements: \(count)")
            }
        } catch {
            print(error)
        }
    }
}


