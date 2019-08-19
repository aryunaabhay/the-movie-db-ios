//
//  Appearance.swift
//  MovieDB
//
//  Created by Aryuna on 8/19/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import UIKit

class Appearance {
    
    static func defaultNavigationAppearance(){
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Colors.primaryDark,
             NSAttributedString.Key.font: Fonts.titleFont]
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
