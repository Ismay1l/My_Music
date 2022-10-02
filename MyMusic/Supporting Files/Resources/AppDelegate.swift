//
//  AppDelegate.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 24.08.22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NetworkMonitor.shared.startMonitoring()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.shared.isSignedIn {
            AuthManager.shared.refreshAccessToken(completion: nil)
            let vc = TabBarController()
            window?.rootViewController = vc
        } else {
            let vc = WelcomeVC()
            vc.title = L10n.titleWelcomePage
            vc.navigationItem.largeTitleDisplayMode = .always
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [.foregroundColor: Asset.Colors.mainBlue.color]
            appearance.largeTitleTextAttributes = [.foregroundColor: Asset.Colors.mainBlue.color]
            vc.navigationItem.standardAppearance = appearance
            let navVC = UINavigationController(rootViewController: vc)
            navVC.navigationBar.prefersLargeTitles = true
            window?.rootViewController = navVC
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainerBrowse: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BrowseModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var persistentContainerFeaturedPl: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FeaturedPlModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var persistentContainerTrack: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var persistentContainerProfile: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProfileModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var persistentContainerSearch: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SearchCategoryModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

