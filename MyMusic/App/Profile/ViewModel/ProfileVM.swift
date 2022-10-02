//
//  ProfileVM.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 29.08.22.
//

import Foundation
import UIKit
import RxRelay
import RxSwift
import Promises
import CoreData

class ProfileVM {
    
    //MARK: - Variables
    private let apiManager: APIManagerProtocol
    private let contextProfile = (UIApplication.shared.delegate as! AppDelegate).persistentContainerProfile.viewContext
    private let dataStackProfile = CoreDataStack(modelName: "ProfileModel")
    var localProfile = [ProfileEntity]()
    
    var model = [String]()
    private let userProfileRelay = BehaviorRelay<UserProfileState?>.init(value: nil)
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Fetch Profile
    func fetchUserProfileData() -> Observable<UserProfileState> {
        apiManager.fetchUserProfile()
            .then { response in
                self.userProfileRelay.accept(.showUserProfile(response))
            }
        return userProfileRelay
            .filter { state in
                state != nil
            }
            .map { state in
                state!
            }
            .asObservable()
    }
    
    //MARK: - Core Data
    private func saveContextProfile() {
        
        do {
            try contextProfile.save()
        } catch {
            print(error)
        }
    }
    
    //MARK: - Save  Result
    func saveProfile(image: String, name: String, country: String, plan: String) {
        let newProfile = ProfileEntity(context: contextProfile)
        newProfile.image = image
        newProfile.name = name
        newProfile.country = country
        newProfile.plan = plan
        saveContextProfile()
    }
    
    //MARK: - Get Result
    func getProfileData() {
        do {
            localProfile = try contextProfile.fetch(ProfileEntity.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    //MARK: - Delete Result
    func deleteAllProfile() {
        let fetchRequest = NSFetchRequest<NSManagedObjectID>.init(entityName: "ProfileEntity")
        fetchRequest.resultType = .managedObjectResultType
        
        do {
            let ids = try dataStackProfile.managedContext.fetch(fetchRequest)
            if ids.isEmpty {
                print("All deleted already")
                return
            }
            let batchDelete = NSBatchDeleteRequest(objectIDs: ids)
            batchDelete.resultType = .resultTypeCount
            
            let batchResult = try self.dataStackProfile.managedContext.execute(batchDelete) as? NSBatchDeleteResult
            if let count = batchResult?.result as? Int {
                print("Deleted elements: \(count)")
            }
        } catch {
            print(error)
        }
    }
}
