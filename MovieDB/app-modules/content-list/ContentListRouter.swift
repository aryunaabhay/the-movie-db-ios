//
//  ContentListRouter.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import UIKit

class ContentListRouter {
    
    static func contentListScreen() -> UIViewController {
        let viewModel = ContentListViewModel(contentType: .movie, sortCategory: .popular)
        return ContentListViewController(viewModel: viewModel)
    }
}
