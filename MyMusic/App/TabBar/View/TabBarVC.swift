
//  TabBarVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVCs()
        configureTabBar()
    }
    
    private func configureTabBar() {
        tabBar.unselectedItemTintColor = Asset.Colors.white.color
        tabBar.backgroundColor = Asset.Colors.lightGray.color
        tabBar.layer.cornerRadius = 22
    }
    
    private func configureVCs() {
        let vc1 = HomeVC()
        let vc2 = LibraryVC()
        let vc3 = SearchVC()
        let vc4 = ProfileVC()
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .never
        
        vc1.title = L10n.titleHomePage
        vc2.title = L10n.titleLibraryPage
        vc3.title = L10n.titleSearchPage
        vc4.title = L10n.titleProfileVCHeader
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Asset.Colors.white.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: Asset.Colors.mainBlue.color]
        vc1.navigationItem.standardAppearance = appearance
        
        let appearance2 = UINavigationBarAppearance()
        appearance2.titleTextAttributes = [.foregroundColor: Asset.Colors.white.color]
        appearance2.largeTitleTextAttributes = [.foregroundColor: Asset.Colors.mainBlue.color]
        vc2.navigationItem.standardAppearance = appearance
        
        let appearance3 = UINavigationBarAppearance()
        appearance3.titleTextAttributes = [.foregroundColor: Asset.Colors.white.color]
        appearance3.largeTitleTextAttributes = [.foregroundColor: Asset.Colors.mainBlue.color]
        vc3.navigationItem.standardAppearance = appearance
        
        let appearance4 = UINavigationBarAppearance()
        appearance4.titleTextAttributes = [.foregroundColor: Asset.Colors.white.color]
        appearance4.largeTitleTextAttributes = [.foregroundColor: Asset.Colors.mainBlue.color]
        vc4.navigationItem.standardAppearance = appearance
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        nav1.tabBarItem = UITabBarItem(title: L10n.titleHomeTabbar, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: L10n.titleLibraryPage, image: UIImage(systemName: "music.note.list"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: L10n.titleSearchPage, image: UIImage(systemName: "magnifyingglass"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: L10n.profileLabel, image: UIImage(systemName: "person.crop.circle"), tag: 4)
        
        let viewControllers = [nav1, nav2, nav3, nav4]
        setViewControllers(viewControllers, animated: true)
    }
}
