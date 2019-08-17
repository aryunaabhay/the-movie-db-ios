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
    
    static func mainScreen(delegate: UITabBarControllerDelegate? = nil) -> UITabBarController {
        let moviesListScreen = ContentListRouter.contentListScreen(contentType: .movie)
        let moviesNavigationController = UINavigationController(rootViewController: moviesListScreen)
        let showsListScreen = ContentListRouter.contentListScreen(contentType: .tvshow)
        let showsNavigationController = UINavigationController(rootViewController: showsListScreen)
        let mainTabBar = MainScreenRouter.tabBar(viewControllers: [moviesNavigationController, showsNavigationController], delegate: delegate)
        return mainTabBar
    }
    
    static func tabBar(viewControllers: [UIViewController], delegate: UITabBarControllerDelegate? = nil) -> UITabBarController {
        let mainTabBar: UITabBarController = UITabBarController()
        mainTabBar.viewControllers = viewControllers
        mainTabBar.delegate = delegate
        return mainTabBar
    }
}
