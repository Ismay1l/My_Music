//
//  AppDelegate.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 24.08.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.shared.isSignedIn {
            AuthManager.shared.refreshAccessToken(completion: nil)
            let vc = CustomTabBarController()
            window?.rootViewController = vc
        } else {
            let vc = WelcomeVC()
            vc.title = L10n.titleWelcomePage
            vc.navigationItem.largeTitleDisplayMode = .always
            let navVC = UINavigationController(rootViewController: vc)
            navVC.navigationBar.prefersLargeTitles = true
            window?.rootViewController = navVC
        }
        
        window?.makeKeyAndVisible()
        print("AccessToken: \(APPDefaultsManager.getString(key: "access_token") ?? "NA")")
        print("RefreshToken: \(APPDefaultsManager.getString(key: "refresh_token") ?? "NA")")
        return true
    }
}

