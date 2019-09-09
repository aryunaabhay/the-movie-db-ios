//
//  ContentListViewModel.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import UIKit

protocol ContentListOutputProtocol {
    var viewController: ContentListDisplayProtocol { get set }
    func showResults(_ results: [VideoContent], isSearchMode: Bool)
    func setState(_ state: ContentListDataState)
}

class ContentListPresenter: ContentListOutputProtocol {
    var viewController: ContentListDisplayProtocol
    
    init(vc: ContentListDisplayProtocol){
        self.viewController = vc
    }
    
    func showResults(_ results: [VideoContent], isSearchMode: Bool) {
        var viewModel = self.viewController.viewModel
        if !isSearchMode {
            viewModel.allObjects = results
        }
        viewModel.displayObjects = results
        viewModel.dataState = results.count > 0 ? .loaded : .noData
        self.viewController.updateViewModel(vm: viewModel)
    }
    
    func setState(_ state: ContentListDataState) {
        var viewModel = self.viewController.viewModel
        viewModel.dataState = state
        self.viewController.updateViewModel(vm: viewModel)
    }
}
