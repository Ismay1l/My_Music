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

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BrowseModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

