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
    
    static func contentListScreen(contentType: ContentType) -> UIViewController {
        let viewModel = ContentListViewModel(contentType: contentType, sortCategory: .popular)
        return ContentListViewController(viewModel: viewModel)
    }
}
