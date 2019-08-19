//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Aryuna on 8/13/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setup()
        return true
    }
    
    func setup(){
        NetworkConnectionObserver().startListening { (reachable) in
            AppConfiguration.isNetworkReachable = reachable
        }
        self.window?.rootViewController = MainScreenRouter.mainScreen()
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Colors.primaryDark,
             NSAttributedString.Key.font: UIFont(name: "Front Page Neue", size: 21)!]
    }
}

