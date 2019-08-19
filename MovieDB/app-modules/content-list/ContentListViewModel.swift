//
//  ContentListViewModel.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import ReactiveSwift

enum ContentType {
    case tvshow, movie
}

enum ContentListDataState {
    case start, loading, noData, loaded, errorLoading
}

class ContentListViewModel {
    var sortCategory: ContentCategory
    var contentType: ContentType
    var apiService: ApiServible
    var allObjects: [VideoContent] = []
    var displayObjects: [VideoContent] = []
    var dataState: MutableProperty<ContentListDataState> = MutableProperty(.start)
    var segmentCategories: [String] {
        return contentType == .movie ? ["Popular", "Top rated", "Upcoming"] : ["Popular", "Top rated"]
    }
    
    init(contentType: ContentType, sortCategory: ContentCategory){
        self.contentType = contentType
        self.sortCategory = sortCategory
        if self.contentType == .movie {
            self.apiService = MoviesApiService(networkingClient: AppConfiguration.movieDBNetworkingClient)
        }else{
            self.apiService = TVShowsApiService(networkingClient: AppConfiguration.movieDBNetworkingClient)
        }
    }
    
    func updateSelectedCategory(selectedIndex: Int) {
        var selected = self.segmentCategories[selectedIndex].lowercased()
        if selected == "top rated" {
            selected = "top_rated"
        }
        if let selectedCategory = ContentCategory(rawValue: selected) {
            self.updateSelectedCategory(selectedCategory)
        }
    }
    
    private func updateSelectedCategory(_ category: ContentCategory){
        self.sortCategory = category
        self.retrieveData()
    }
    
    func retrieveData(){
        self.dataState.value = .loading
        self.apiService.listContent(sortedBy: self.sortCategory).then { [weak self] (objects) in
            guard let this = self else { return }
            if let videoContentArray = objects as? [VideoContent] {
            this.allObjects = videoContentArray
            this.displayObjects = videoContentArray
            this.dataState.value = videoContentArray.count > 0 ? .loaded : .noData
            }
        }.catch { [weak self] (error) in
            self?.handleError(error)
        }
    }
    
    func handleError(_ error: Error){
        self.dataState.value = .errorLoading
    }
    
    func searchContent(by text: String) {
       self.dataState.value = .loading
    }
}
