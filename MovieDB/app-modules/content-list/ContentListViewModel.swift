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
            self.apiService = MoviesApiService(networkingClient: App.movieDBNetworkingClient)
        }else{
            self.apiService = TVShowsApiService(networkingClient: App.movieDBNetworkingClient)
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
    
    func retrieveData(_ completion: (() -> ())? = nil){
        self.dataState.value = .loading
        self.apiService.listContent(sortedBy: self.sortCategory, online: App.isNetworkReachable).then { [weak self] (objects) in
            guard let this = self else { return }
            let videoContentArray = objects as? [VideoContent] ?? []
            this.allObjects = videoContentArray
            this.displayObjects = videoContentArray
            this.dataState.value = videoContentArray.count > 0 ? .loaded : .noData
            completion?()
        }.catch { [weak self] (error) in
            self?.handleError(error)
            completion?()
        }
    }
    
    func handleError(_ error: Error){
        self.dataState.value = .errorLoading
    }
    
    func searchContent(by text: String, completion: (() -> ())? = nil) {
        if text.count < 4 { return }
        self.dataState.value = .loading
        self.apiService.search(queryTxt: text, category: self.sortCategory, online: App.isNetworkReachable).then { [weak self](results) in
            guard let this = self else { return }
            let objectResults = results as? [VideoContent] ?? []
            this.displayObjects = objectResults
            this.dataState.value = objectResults.count > 0 ? .loaded : .noData
            completion?()
        }.catch { [weak self] (error) in
            self?.handleError(error)
            completion?()
        }
    }
    
    func resetSearch(){
        self.displayObjects = self.allObjects
        self.dataState.value = .loaded
    }
}
