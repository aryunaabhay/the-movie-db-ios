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

enum ContentListViewState {
    case start, loadingData, noData, dataLoaded, errorLoadingData
}

class ContentListViewModel {
    var allObjects: [VideoContent] = []
    var displayObjects: [VideoContent] = []
    var sortCategory: ContentCategory
    var contentType: ContentType
    var viewState: MutableProperty<ContentListViewState> = MutableProperty(.start)
    var segmentCategories: [String] {
        return contentType == .movie ? ["Popular", "Top rated", "Upcoming"] : ["Popular", "Top rated"]
    }
    
    init(contentType: ContentType, sortCategory: ContentCategory){
        self.contentType = contentType
        self.sortCategory = sortCategory
    }
    
    func retrieveData(){
        self.viewState.value = .loadingData
        // TODO: check if we can abstract this better
        if self.contentType == .movie {
            MoviesService.listContent(sortedBy: self.sortCategory).then { [weak self] (movies) in
                guard let this = self else { return }
                this.allObjects = movies
                this.displayObjects = movies
                this.viewState.value = movies.count > 0 ? .dataLoaded : .noData
            }.catch { [weak self] (error) in
                self?.handleError(error)
            }
        } else {
            TVShowsService.listContent(sortedBy: self.sortCategory).then { [weak self] (shows) in
                guard let this = self else { return }
                this.allObjects = shows
                this.displayObjects = shows
                this.viewState.value = shows.count > 0 ? .dataLoaded : .noData
            }.catch { [weak self] (error) in
                self?.handleError(error)
            }
        }
    }
    
    func handleError(_ error: Error){
        self.viewState.value = .errorLoadingData
    }
}
