//
//  ContentListViewModel.swift
//  MovieDB
//
//  Created by Aryuna on 9/8/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

protocol ContentListViewModelProtocol {
    var dataState: ContentListDataState { get set }
    var allObjects: [VideoContent] { get set }
    var displayObjects: [VideoContent] { get set }
}

struct ContentListViewModel: ContentListViewModelProtocol {
    var allObjects: [VideoContent] = []
    var displayObjects: [VideoContent] = []
    var dataState: ContentListDataState = .noData
}
