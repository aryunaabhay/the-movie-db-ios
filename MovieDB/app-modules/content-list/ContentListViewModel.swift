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
    var allObjects: [VideoContent] = []
    var displayObjects: [VideoContent] = []
    var sortCategory: ContentCategory
    var contentType: ContentType
    var dataState: MutableProperty<ContentListDataState> = MutableProperty(.start)
    var segmentCategories: [String] {
        return contentType == .movie ? ["Popular", "Top rated", "Upcoming"] : ["Popular", "Top rated"]
    }
    
    init(contentType: ContentType, sortCategory: ContentCategory){
        self.contentType = contentType
        self.sortCategory = sortCategory
    }
    
    func retrieveData(){
        self.dataState.value = .loading
        // TODO: check if we can abstract this more
        if self.contentType == .movie {
            let moviesApiService = MoviesApiService(networkingClient: AppConfiguration.movieDBNetworkingClient)
            moviesApiService.listContent(sortedBy: self.sortCategory).then { [weak self] (movies) in
                guard let this = self else { return }
                this.allObjects = movies
                this.displayObjects = movies
                this.dataState.value = movies.count > 0 ? .loaded : .noData
            }.catch { [weak self] (error) in
                self?.handleError(error)
            }
        } else {
            let showsApiService = TVShowsApiService(networkingClient: AppConfiguration.movieDBNetworkingClient)
            showsApiService.listContent(sortedBy: self.sortCategory).then { [weak self] (shows) in
                guard let this = self else { return }
                this.allObjects = shows
                this.displayObjects = shows
                this.dataState.value = shows.count > 0 ? .loaded : .noData
            }.catch { [weak self] (error) in
                self?.handleError(error)
            }
        }
    }
    
    func handleError(_ error: Error){
        self.dataState.value = .errorLoading
    }
}
