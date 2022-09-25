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

class ProfileVM {
    
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Variables
    var model = [String]()
    private let userProfileRelay = BehaviorRelay<UserProfileState?>.init(value: nil)
    
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
}
