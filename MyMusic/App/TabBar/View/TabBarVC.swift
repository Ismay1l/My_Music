
//  TabBarVC.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 25.08.22.
//

import UIKit
import RAMAnimatedTabBarController

class CustomTabBarController: RAMAnimatedTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        let vc1 = HomeVC()
        let vc2 = SearchVC()
        let vc3 = LibraryVC()
        let vc4 = ProfileVC()
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .never
        
        vc1.title = L10n.titleHomePage
        vc2.title = L10n.titleSearchPage
        vc3.title = L10n.titleLibraryPage
        vc4.title = L10n.titleProfileVCHeader
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        nav1.tabBarItem = RAMAnimatedTabBarItem(title: L10n.titleHomeTabbar, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = RAMAnimatedTabBarItem(title: L10n.titleSearchPage, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        nav3.tabBarItem = RAMAnimatedTabBarItem(title: L10n.titleLibraryPage, image: UIImage(systemName: "music.note.list"), tag: 3)
        nav4.tabBarItem = RAMAnimatedTabBarItem(title:L10n.profileLabel, image: UIImage(systemName: "person.crop.circle"), tag: 4)
        
        (nav1.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
        (nav2.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
        (nav3.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
        (nav4.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
        
        let viewControllers = [nav1, nav2, nav3, nav4]
        setViewControllers(viewControllers, animated: true)
    }
}
