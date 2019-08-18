//
//  MainScreenRouter.swift
//  MovieDB
//
//  Created by Aryuna on 8/17/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import UIKit

class MainScreenRouter {
    
    static func mainScreen(delegate: UITabBarControllerDelegate? = nil) -> UIViewController {
        let moviesListScreen = UINavigationController(rootViewController: ContentListRouter.contentListScreen(contentType: .movie))
        let showsListScreen = UINavigationController(rootViewController: ContentListRouter.contentListScreen(contentType: .tvshow))
        let mainTabBar = MainScreenRouter.tabBar(viewControllers: [moviesListScreen, showsListScreen], delegate: delegate)
        return mainTabBar
    }
    
    static func tabBar(viewControllers: [UIViewController], delegate: UITabBarControllerDelegate? = nil) -> UITabBarController {
        let mainTabBar: UITabBarController = UITabBarController()
        mainTabBar.viewControllers = viewControllers
        mainTabBar.delegate = delegate
        return mainTabBar
    }
}
